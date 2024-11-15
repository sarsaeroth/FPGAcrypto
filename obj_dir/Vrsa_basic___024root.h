// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vrsa_basic.h for the primary calling header

#ifndef VERILATED_VRSA_BASIC___024ROOT_H_
#define VERILATED_VRSA_BASIC___024ROOT_H_  // guard

#include "verilated.h"


class Vrsa_basic__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vrsa_basic___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(reset,0,0);
    CData/*1:0*/ rsa_top__DOT__state;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__reset__0;
    CData/*0:0*/ __VactContinue;
    VL_IN(message,31,0);
    VL_IN(e,31,0);
    VL_IN(n,31,0);
    VL_OUT(cipher,31,0);
    IData/*31:0*/ rsa_top__DOT__result;
    IData/*31:0*/ rsa_top__DOT__base;
    IData/*31:0*/ rsa_top__DOT__exponent;
    IData/*31:0*/ rsa_top__DOT__modulus;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vrsa_basic__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vrsa_basic___024root(Vrsa_basic__Syms* symsp, const char* v__name);
    ~Vrsa_basic___024root();
    VL_UNCOPYABLE(Vrsa_basic___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
