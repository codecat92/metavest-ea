//+------------------------------------------------------------------+
//|                                                     metavest.mq4 |
//|                                                        codecat92 |
//+------------------------------------------------------------------+
#property copyright "codecat92"
#property version   "1.00"
#property strict

// ===== INPUT PARAMETERS =====
input int    MA_Fast_Period = 20;
input int    MA_Slow_Period = 50;
input double Lot_Size       = 0.01;
input int    Stop_Loss      = 20;
input int    Take_Profit    = 40;

//+------------------------------------------------------------------+
//| Helper Function - Cek apakah sudah ada posisi terbuka            |
//+------------------------------------------------------------------+
bool HasOpenPosition()
  {
   // Loop semua posisi yang sedang terbuka
   for(int i = 0; i < OrdersTotal(); i++)
     {
      // Pilih posisi ke-i
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         // Kalau ada posisi di pair yang sama → return true
         if(OrderSymbol() == Symbol())
            return true;
        }
     }
   // Tidak ada posisi terbuka → return false
   return false;
  }

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("Metavest EA started.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| OnTick - Logika utama bot                                        |
//+------------------------------------------------------------------+
void OnTick()
  {
   // === LANGKAH 1: Cek posisi terbuka ===
   // Kalau sudah ada posisi, jangan buka lagi
   if(HasOpenPosition())
      return;

   // === LANGKAH 2: Hitung nilai MA ===
   double maFast     = iMA(Symbol(), Period(), MA_Fast_Period, 0, MODE_SMA, PRICE_CLOSE, 0);
   double maSlow     = iMA(Symbol(), Period(), MA_Slow_Period, 0, MODE_SMA, PRICE_CLOSE, 0);

   // MA di candle sebelumnya (untuk deteksi crossover)
   double maFastPrev = iMA(Symbol(), Period(), MA_Fast_Period, 0, MODE_SMA, PRICE_CLOSE, 1);
   double maSlowPrev = iMA(Symbol(), Period(), MA_Slow_Period, 0, MODE_SMA, PRICE_CLOSE, 1);

   // === LANGKAH 3: Hitung SL dan TP ===
   double point    = MarketInfo(Symbol(), MODE_POINT);
   double slPoints = Stop_Loss   * 10 * point;
   double tpPoints = Take_Profit * 10 * point;

   // === LANGKAH 4: Deteksi sinyal ===

   // Golden Cross → MA Fast memotong MA Slow dari bawah ke atas → BUY
   bool isBuySignal  = (maFastPrev < maSlowPrev) && (maFast > maSlow);

   // Death Cross → MA Fast memotong MA Slow dari atas ke bawah → SELL
   bool isSellSignal = (maFastPrev > maSlowPrev) && (maFast < maSlow);

   // === LANGKAH 5: Eksekusi order ===
   if(isBuySignal)
     {
      double entryPrice = Ask;
      double sl         = entryPrice - slPoints;
      double tp         = entryPrice + tpPoints;

      OrderSend(Symbol(), OP_BUY, Lot_Size, entryPrice, 3, sl, tp, "Metavest BUY", 0, 0, clrGreen);
      Print("BUY order sent | Entry: ", entryPrice, " SL: ", sl, " TP: ", tp);
     }

   if(isSellSignal)
     {
      double entryPrice = Bid;
      double sl         = entryPrice + slPoints;
      double tp         = entryPrice - tpPoints;

      OrderSend(Symbol(), OP_SELL, Lot_Size, entryPrice, 3, sl, tp, "Metavest SELL", 0, 0, clrRed);
      Print("SELL order sent | Entry: ", entryPrice, " SL: ", sl, " TP: ", tp);
     }
  }

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print("Metavest EA stopped.");
  }