//+------------------------------------------------------------------+
//|                                                     metavest.mq4 |
//|                                                        codecat92 |
//+------------------------------------------------------------------+
#property copyright "codecat92"
#property version   "1.00"
#property strict

// ===== INPUT PARAMETERS =====
input int    MA_Fast_Period = 5;
input int    MA_Slow_Period = 40;
input double Lot_Size       = 0.01;
input int    Stop_Loss      = 80;
input int    Take_Profit    = 180;
input int RSI_Period     = 21; //Period
input int RSI_Overbought = 90; //Overbought
input int RSI_Oversold = 35; //Oversold

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

   // === LANGKAH 3: Hitung nilai RSI ===
   double rsi = iRSI(Symbol(), Period(), RSI_Period, PRICE_CLOSE, 0);
   Print("MA Fast: ", maFast, " MA Slow: ", maSlow, " RSI: ", rsi);


   // === LANGKAH 4: Hitung SL dan TP ===
   double point    = MarketInfo(Symbol(), MODE_POINT);
   double slPoints = Stop_Loss   * 10 * point;
   double tpPoints = Take_Profit * 10 * point;

   // === LANGKAH 5: Deteksi sinyal ===

   // Golden Cross → MA Fast memotong MA Slow dari bawah ke atas → BUY // dan RSI di bawah 70
   bool isBuySignal  = (maFastPrev < maSlowPrev) && (maFast > maSlow) && (rsi < RSI_Overbought);

   // Death Cross → MA Fast memotong MA Slow dari atas ke bawah → SELL // dan RSI di atas 30
   bool isSellSignal = (maFastPrev > maSlowPrev) && (maFast < maSlow) && (rsi > RSI_Oversold);

   // === LANGKAH 5: Eksekusi order ===
   if(isBuySignal)
     {
      double entryPrice = Ask;
      double sl         = entryPrice - slPoints;
      double tp         = entryPrice + tpPoints;

      int ticket = OrderSend(Symbol(), OP_BUY, Lot_Size, entryPrice, 3, sl, tp, "Metavest BUY", 0, 0, clrGreen);
      if(ticket < 0)
        Print("BUY order failed | Error code: ", GetLastError());
      else
        Print("BUY order sent | Entry: ", entryPrice, " SL: ", sl, " TP: ", tp);
     }

   if(isSellSignal)
     {
      double entryPrice = Bid;
      double sl         = entryPrice + slPoints;
      double tp         = entryPrice - tpPoints;

      int ticket = OrderSend(Symbol(), OP_SELL, Lot_Size, entryPrice, 3, sl, tp, "Metavest SELL", 0, 0, clrRed);
      if(ticket < 0)
        Print("SELL order failed | Error code: ", GetLastError());
      else
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