// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VRSA_BASIC__SYMS_H_
#define VERILATED_VRSA_BASIC__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vrsa_basic.h"

// INCLUDE MODULE CLASSES
#include "Vrsa_basic___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vrsa_basic__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vrsa_basic* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vrsa_basic___024root           TOP;

    // CONSTRUCTORS
    Vrsa_basic__Syms(VerilatedContext* contextp, const char* namep, Vrsa_basic* modelp);
    ~Vrsa_basic__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
