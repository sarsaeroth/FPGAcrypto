// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrsa_basic.h for the primary calling header

#include "Vrsa_basic__pch.h"
#include "Vrsa_basic___024root.h"

VL_ATTR_COLD void Vrsa_basic___024root___eval_static(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vrsa_basic___024root___eval_initial(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
    vlSelf->__Vtrigprevexpr___TOP__reset__0 = vlSelf->reset;
}

VL_ATTR_COLD void Vrsa_basic___024root___eval_final(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vrsa_basic___024root___eval_settle(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrsa_basic___024root___dump_triggers__act(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk or posedge reset)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrsa_basic___024root___dump_triggers__nba(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk or posedge reset)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vrsa_basic___024root___ctor_var_reset(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->reset = VL_RAND_RESET_I(1);
    vlSelf->message = VL_RAND_RESET_I(32);
    vlSelf->e = VL_RAND_RESET_I(32);
    vlSelf->n = VL_RAND_RESET_I(32);
    vlSelf->cipher = VL_RAND_RESET_I(32);
    vlSelf->done = VL_RAND_RESET_I(1);
    vlSelf->rsa_top__DOT__result = VL_RAND_RESET_Q(64);
    vlSelf->rsa_top__DOT__base = VL_RAND_RESET_Q(64);
    vlSelf->rsa_top__DOT__modulus = VL_RAND_RESET_Q(64);
    vlSelf->rsa_top__DOT__exponent = VL_RAND_RESET_I(32);
    vlSelf->rsa_top__DOT__state = VL_RAND_RESET_I(2);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__reset__0 = VL_RAND_RESET_I(1);
}
