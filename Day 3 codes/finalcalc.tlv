\m5_TLV_version 1d: tl-x.org
\m5
      //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
     |calc
   @0
    $valid = & $rand_valid[1:0];  // Valid with 1/4 probability
                               // (& over two random bits).
   
   // DUT (Design Under Test)
   |calc
   ?$valid
   // Pythagoras's Theorem
   @1
     $aa_sq[7:0] = $aa[3:0] ** 2;
     $bb_sq[7:0] = $bb[3:0] ** 2;
   @2
     $cc_sq[8:0] = $aa_sq + $bb_sq;
   @3
     $cc[4:0] = sqrt($cc_sq);
   
   // Assert these to end simulation (before the cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule

   
   // Assert these to end simulation (before the cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
