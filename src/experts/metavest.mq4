//+------------------------------------------------------------------+
//|                                                     metavest.mq4 |
//|                                                        codecat92 |
//|                                                                  |
//+------------------------------------------------------------------+

// ===== METADATA =====
#property copyright "codecat92"
#property version   "1.00"
#property strict

// ===== INPUT PARAMETERS =====
// Ini adalah variabel yang bisa diubah trader
// langsung dari tampilan MT4 tanpa edit kode
input int    MA_Fast_Period = 20;    // Periode MA cepat
input int    MA_Slow_Period = 50;    // Periode MA lambat
input double Lot_Size       = 0.01;  // Ukuran lot
input int    Stop_Loss      = 20;    // Stop Loss dalam pips
input int    Take_Profit    = 40;    // Take Profit dalam pips

//+------------------------------------------------------------------+
//| Fungsi OnInit - dijalankan sekali saat EA dipasang               |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("Metavest EA started.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Fungsi OnTick - dijalankan setiap harga bergerak                 |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Hitung nilai MA Fast dan MA Slow
   double maFast = iMA(Symbol(), Period(), MA_Fast_Period, 0, MODE_SMA, PRICE_CLOSE, 0);
   double maSlow = iMA(Symbol(), Period(), MA_Slow_Period, 0, MODE_SMA, PRICE_CLOSE, 0);

   // Cetak nilai MA di log (untuk debugging)
   Print("MA Fast: ", maFast, " | MA Slow: ", maSlow);
  }

//+------------------------------------------------------------------+
//| Fungsi OnDeinit - dijalankan sekali saat EA dilepas              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print("Metavest EA stopped.");
  }