// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrsa_basic.h for the primary calling header

#include "Vrsa_basic__pch.h"
#include "Vrsa_basic___024root.h"

void Vrsa_basic___024root___eval_act(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vrsa_basic___024root___nba_sequent__TOP__0(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___nba_sequent__TOP__0\n"); );
    // Init
    CData/*1:0*/ __Vdly__rsa_top__DOT__state;
    __Vdly__rsa_top__DOT__state = 0;
    QData/*63:0*/ __Vdly__rsa_top__DOT__result;
    __Vdly__rsa_top__DOT__result = 0;
    QData/*63:0*/ __Vdly__rsa_top__DOT__base;
    __Vdly__rsa_top__DOT__base = 0;
    IData/*31:0*/ __Vdly__rsa_top__DOT__exponent;
    __Vdly__rsa_top__DOT__exponent = 0;
    QData/*63:0*/ __Vdly__rsa_top__DOT__modulus;
    __Vdly__rsa_top__DOT__modulus = 0;
    CData/*0:0*/ __Vdly__done;
    __Vdly__done = 0;
    // Body
    __Vdly__done = vlSelf->done;
    __Vdly__rsa_top__DOT__modulus = vlSelf->rsa_top__DOT__modulus;
    __Vdly__rsa_top__DOT__exponent = vlSelf->rsa_top__DOT__exponent;
    __Vdly__rsa_top__DOT__base = vlSelf->rsa_top__DOT__base;
    __Vdly__rsa_top__DOT__result = vlSelf->rsa_top__DOT__result;
    __Vdly__rsa_top__DOT__state = vlSelf->rsa_top__DOT__state;
    if (vlSelf->reset) {
        __Vdly__rsa_top__DOT__state = 0U;
        __Vdly__rsa_top__DOT__result = 1ULL;
        __Vdly__rsa_top__DOT__base = 0ULL;
        __Vdly__rsa_top__DOT__exponent = 0U;
        __Vdly__rsa_top__DOT__modulus = 0ULL;
        __Vdly__done = 0U;
        vlSelf->cipher = 0U;
    } else if ((0U == (IData)(vlSelf->rsa_top__DOT__state))) {
        __Vdly__rsa_top__DOT__result = 1ULL;
        __Vdly__rsa_top__DOT__base = VL_MODDIV_QQQ(64, 
                                                   (0x14eeaULL 
                                                    * (QData)((IData)(vlSelf->message))), (QData)((IData)(vlSelf->n)));
        __Vdly__rsa_top__DOT__exponent = vlSelf->e;
        __Vdly__rsa_top__DOT__modulus = (QData)((IData)(vlSelf->n));
        __Vdly__rsa_top__DOT__state = 1U;
        __Vdly__done = 0U;
    } else if ((1U == (IData)(vlSelf->rsa_top__DOT__state))) {
        if ((0U < vlSelf->rsa_top__DOT__exponent)) {
            if ((1U & vlSelf->rsa_top__DOT__exponent)) {
                __Vdly__rsa_top__DOT__result = VL_MODDIV_QQQ(64, 
                                                             (vlSelf->rsa_top__DOT__result 
                                                              * vlSelf->rsa_top__DOT__base), vlSelf->rsa_top__DOT__modulus);
            }
            __Vdly__rsa_top__DOT__exponent = VL_SHIFTR_III(32,32,32, vlSelf->rsa_top__DOT__exponent, 1U);
            __Vdly__rsa_top__DOT__base = VL_MODDIV_QQQ(64, 
                                                       (vlSelf->rsa_top__DOT__base 
                                                        * vlSelf->rsa_top__DOT__base), vlSelf->rsa_top__DOT__modulus);
        } else {
            __Vdly__rsa_top__DOT__state = 2U;
        }
    } else if ((2U == (IData)(vlSelf->rsa_top__DOT__state))) {
        if (vlSelf->done) {
            __Vdly__rsa_top__DOT__state = 0U;
        } else {
            vlSelf->cipher = (IData)(vlSelf->rsa_top__DOT__result);
            __Vdly__done = 1U;
        }
    } else {
        __Vdly__rsa_top__DOT__state = 0U;
    }
    vlSelf->rsa_top__DOT__state = __Vdly__rsa_top__DOT__state;
    vlSelf->rsa_top__DOT__result = __Vdly__rsa_top__DOT__result;
    vlSelf->rsa_top__DOT__base = __Vdly__rsa_top__DOT__base;
    vlSelf->rsa_top__DOT__exponent = __Vdly__rsa_top__DOT__exponent;
    vlSelf->rsa_top__DOT__modulus = __Vdly__rsa_top__DOT__modulus;
    vlSelf->done = __Vdly__done;
}

void Vrsa_basic___024root___eval_nba(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vrsa_basic___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vrsa_basic___024root___eval_triggers__act(Vrsa_basic___024root* vlSelf);

bool Vrsa_basic___024root___eval_phase__act(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vrsa_basic___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vrsa_basic___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vrsa_basic___024root___eval_phase__nba(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vrsa_basic___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrsa_basic___024root___dump_triggers__nba(Vrsa_basic___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vrsa_basic___024root___dump_triggers__act(Vrsa_basic___024root* vlSelf);
#endif  // VL_DEBUG

void Vrsa_basic___024root___eval(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vrsa_basic___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("designs/rsa_basic.v", 1, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vrsa_basic___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("designs/rsa_basic.v", 1, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vrsa_basic___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vrsa_basic___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vrsa_basic___024root___eval_debug_assertions(Vrsa_basic___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrsa_basic__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrsa_basic___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
}
#endif  // VL_DEBUG
