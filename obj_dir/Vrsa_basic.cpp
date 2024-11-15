// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vrsa_basic__pch.h"

//============================================================
// Constructors

Vrsa_basic::Vrsa_basic(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vrsa_basic__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , reset{vlSymsp->TOP.reset}
    , message{vlSymsp->TOP.message}
    , e{vlSymsp->TOP.e}
    , n{vlSymsp->TOP.n}
    , cipher{vlSymsp->TOP.cipher}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vrsa_basic::Vrsa_basic(const char* _vcname__)
    : Vrsa_basic(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vrsa_basic::~Vrsa_basic() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vrsa_basic___024root___eval_debug_assertions(Vrsa_basic___024root* vlSelf);
#endif  // VL_DEBUG
void Vrsa_basic___024root___eval_static(Vrsa_basic___024root* vlSelf);
void Vrsa_basic___024root___eval_initial(Vrsa_basic___024root* vlSelf);
void Vrsa_basic___024root___eval_settle(Vrsa_basic___024root* vlSelf);
void Vrsa_basic___024root___eval(Vrsa_basic___024root* vlSelf);

void Vrsa_basic::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vrsa_basic::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vrsa_basic___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vrsa_basic___024root___eval_static(&(vlSymsp->TOP));
        Vrsa_basic___024root___eval_initial(&(vlSymsp->TOP));
        Vrsa_basic___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vrsa_basic___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vrsa_basic::eventsPending() { return false; }

uint64_t Vrsa_basic::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vrsa_basic::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vrsa_basic___024root___eval_final(Vrsa_basic___024root* vlSelf);

VL_ATTR_COLD void Vrsa_basic::final() {
    Vrsa_basic___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vrsa_basic::hierName() const { return vlSymsp->name(); }
const char* Vrsa_basic::modelName() const { return "Vrsa_basic"; }
unsigned Vrsa_basic::threads() const { return 1; }
void Vrsa_basic::prepareClone() const { contextp()->prepareClone(); }
void Vrsa_basic::atClone() const {
    contextp()->threadPoolpOnClone();
}

//============================================================
// Trace configuration

VL_ATTR_COLD void Vrsa_basic::trace(VerilatedVcdC* tfp, int levels, int options) {
    vl_fatal(__FILE__, __LINE__, __FILE__,"'Vrsa_basic::trace()' called on model that was Verilated without --trace option");
}
