/* Generated automatically by the program 'build/genpreds'
   from the machine description file '/workdir/openwrt/build_dir/toolchain-arm_cortex-a5+neon-vfpv4_gcc-12.3.0_musl_eabi/gcc-12.3.0/gcc/config/arm/arm.md'.  */

#ifndef GCC_TM_PREDS_H
#define GCC_TM_PREDS_H

#ifdef HAVE_MACHINE_MODES
extern bool general_operand (rtx, machine_mode);
extern bool address_operand (rtx, machine_mode);
extern bool register_operand (rtx, machine_mode);
extern bool pmode_register_operand (rtx, machine_mode);
extern bool scratch_operand (rtx, machine_mode);
extern bool immediate_operand (rtx, machine_mode);
extern bool const_int_operand (rtx, machine_mode);
extern bool const_scalar_int_operand (rtx, machine_mode);
extern bool const_double_operand (rtx, machine_mode);
extern bool nonimmediate_operand (rtx, machine_mode);
extern bool nonmemory_operand (rtx, machine_mode);
extern bool push_operand (rtx, machine_mode);
extern bool pop_operand (rtx, machine_mode);
extern bool memory_operand (rtx, machine_mode);
extern bool indirect_operand (rtx, machine_mode);
extern bool ordered_comparison_operator (rtx, machine_mode);
extern bool comparison_operator (rtx, machine_mode);
extern bool const_1_to_4_operand (rtx, machine_mode);
extern bool const_2_4_8_16_operand (rtx, machine_mode);
extern bool alu_shift_operator_lsl_1_to_4 (rtx, machine_mode);
extern bool alu_shift_reg_p (rtx, machine_mode);
extern bool s_register_operand (rtx, machine_mode);
extern bool mve_memory_operand (rtx, machine_mode);
extern bool mve_scatter_memory (rtx, machine_mode);
extern bool mve_imm_16 (rtx, machine_mode);
extern bool mve_imm_7 (rtx, machine_mode);
extern bool mve_imm_8 (rtx, machine_mode);
extern bool mve_imm_15 (rtx, machine_mode);
extern bool mve_imm_31 (rtx, machine_mode);
extern bool mve_imm_32 (rtx, machine_mode);
extern bool mve_imm_selective_upto_8 (rtx, machine_mode);
extern bool guard_addr_operand (rtx, machine_mode);
extern bool guard_operand (rtx, machine_mode);
extern bool vpr_register_operand (rtx, machine_mode);
extern bool imm_for_neon_inv_logic_operand (rtx, machine_mode);
extern bool neon_inv_logic_op2 (rtx, machine_mode);
extern bool imm_for_neon_logic_operand (rtx, machine_mode);
extern bool neon_logic_op2 (rtx, machine_mode);
extern bool arm_hard_general_register_operand (rtx, machine_mode);
extern bool low_register_operand (rtx, machine_mode);
extern bool low_reg_or_int_operand (rtx, machine_mode);
extern bool arm_general_register_operand (rtx, machine_mode);
extern bool arm_low_register_operand (rtx, machine_mode);
extern bool arm_general_adddi_operand (rtx, machine_mode);
extern bool vfp_register_operand (rtx, machine_mode);
extern bool vfp_hard_register_operand (rtx, machine_mode);
extern bool zero_operand (rtx, machine_mode);
extern bool minus_one_operand (rtx, machine_mode);
extern bool reg_or_zero_operand (rtx, machine_mode);
extern bool subreg_lowpart_operator (rtx, machine_mode);
extern bool reg_or_int_operand (rtx, machine_mode);
extern bool arm_immediate_operand (rtx, machine_mode);
extern bool arm_immediate_di_operand (rtx, machine_mode);
extern bool arm_neg_immediate_operand (rtx, machine_mode);
extern bool arm_not_immediate_operand (rtx, machine_mode);
extern bool const0_operand (rtx, machine_mode);
extern bool arm_rhs_operand (rtx, machine_mode);
extern bool arm_rhsm_operand (rtx, machine_mode);
extern bool const_int_I_operand (rtx, machine_mode);
extern bool const_int_M_operand (rtx, machine_mode);
extern bool const_int_coproc_operand (rtx, machine_mode);
extern bool const_int_ccde1_operand (rtx, machine_mode);
extern bool const_int_ccde2_operand (rtx, machine_mode);
extern bool const_int_ccde3_operand (rtx, machine_mode);
extern bool const_int_vcde1_operand (rtx, machine_mode);
extern bool const_int_vcde2_operand (rtx, machine_mode);
extern bool const_int_vcde3_operand (rtx, machine_mode);
extern bool const_int_mve_cde1_operand (rtx, machine_mode);
extern bool const_int_mve_cde2_operand (rtx, machine_mode);
extern bool const_int_mve_cde3_operand (rtx, machine_mode);
extern bool shift_amount_operand (rtx, machine_mode);
extern bool const_neon_scalar_shift_amount_operand (rtx, machine_mode);
extern bool ssat16_imm (rtx, machine_mode);
extern bool usat16_imm (rtx, machine_mode);
extern bool ldrd_strd_offset_operand (rtx, machine_mode);
extern bool arm_add_operand (rtx, machine_mode);
extern bool arm_adddi_operand (rtx, machine_mode);
extern bool arm_anddi_operand (rtx, machine_mode);
extern bool arm_iordi_operand (rtx, machine_mode);
extern bool arm_xordi_operand (rtx, machine_mode);
extern bool arm_addimm_operand (rtx, machine_mode);
extern bool arm_not_operand (rtx, machine_mode);
extern bool arm_adcimm_operand (rtx, machine_mode);
extern bool arm_di_operand (rtx, machine_mode);
extern bool offsettable_memory_operand (rtx, machine_mode);
extern bool call_memory_operand (rtx, machine_mode);
extern bool arm_reload_memory_operand (rtx, machine_mode);
extern bool vfp_compare_operand (rtx, machine_mode);
extern bool index_operand (rtx, machine_mode);
extern bool shiftable_operator (rtx, machine_mode);
extern bool shiftable_operator_strict_it (rtx, machine_mode);
extern bool logical_binary_operator (rtx, machine_mode);
extern bool commutative_binary_operator (rtx, machine_mode);
extern bool shift_operator (rtx, machine_mode);
extern bool shift_nomul_operator (rtx, machine_mode);
extern bool sat_shift_operator (rtx, machine_mode);
extern bool long_shift_imm (rtx, machine_mode);
extern bool arm_reg_or_long_shift_imm (rtx, machine_mode);
extern bool mult_operator (rtx, machine_mode);
extern bool thumb_16bit_operator (rtx, machine_mode);
extern bool equality_operator (rtx, machine_mode);
extern bool expandable_comparison_operator (rtx, machine_mode);
extern bool arm_comparison_operator (rtx, machine_mode);
extern bool arm_comparison_operator_mode (rtx, machine_mode);
extern bool arm_comparison_operation (rtx, machine_mode);
extern bool lt_ge_comparison_operator (rtx, machine_mode);
extern bool arm_carry_operation (rtx, machine_mode);
extern bool arm_borrow_operation (rtx, machine_mode);
extern bool arm_vsel_comparison_operator (rtx, machine_mode);
extern bool arm_cond_move_operator (rtx, machine_mode);
extern bool nz_comparison_operator (rtx, machine_mode);
extern bool minmax_operator (rtx, machine_mode);
extern bool cc_register (rtx, machine_mode);
extern bool dominant_cc_register (rtx, machine_mode);
extern bool cc_register_operand (rtx, machine_mode);
extern bool arm_extendqisi_mem_op (rtx, machine_mode);
extern bool arm_reg_or_extendqisi_mem_op (rtx, machine_mode);
extern bool power_of_two_operand (rtx, machine_mode);
extern bool nonimmediate_di_operand (rtx, machine_mode);
extern bool di_operand (rtx, machine_mode);
extern bool nonimmediate_soft_df_operand (rtx, machine_mode);
extern bool soft_df_operand (rtx, machine_mode);
extern bool hard_sf_operand (rtx, machine_mode);
extern bool hard_df_operand (rtx, machine_mode);
extern bool clear_multiple_operation (rtx, machine_mode);
extern bool clear_vfp_multiple_operation (rtx, machine_mode);
extern bool load_multiple_operation (rtx, machine_mode);
extern bool store_multiple_operation (rtx, machine_mode);
extern bool pop_multiple_return (rtx, machine_mode);
extern bool pop_multiple_fp (rtx, machine_mode);
extern bool multi_register_push (rtx, machine_mode);
extern bool push_mult_memory_operand (rtx, machine_mode);
extern bool thumb1_cmp_operand (rtx, machine_mode);
extern bool thumb1_cmpneg_operand (rtx, machine_mode);
extern bool thumb_cbrch_target_operand (rtx, machine_mode);
extern bool imm_or_reg_operand (rtx, machine_mode);
extern bool const_multiple_of_8_operand (rtx, machine_mode);
extern bool imm_for_neon_mov_operand (rtx, machine_mode);
extern bool imm_for_neon_lshift_operand (rtx, machine_mode);
extern bool imm_for_neon_rshift_operand (rtx, machine_mode);
extern bool imm_lshift_or_reg_neon (rtx, machine_mode);
extern bool imm_rshift_or_reg_neon (rtx, machine_mode);
extern bool cmpdi_operand (rtx, machine_mode);
extern bool arm_sync_memory_operand (rtx, machine_mode);
extern bool vect_par_constant_high (rtx, machine_mode);
extern bool vect_par_constant_low (rtx, machine_mode);
extern bool const_double_vcvt_power_of_two_reciprocal (rtx, machine_mode);
extern bool const_double_vcvt_power_of_two (rtx, machine_mode);
extern bool neon_struct_operand (rtx, machine_mode);
extern bool mve_struct_operand (rtx, machine_mode);
extern bool neon_permissive_struct_operand (rtx, machine_mode);
extern bool neon_perm_struct_or_reg_operand (rtx, machine_mode);
extern bool add_operator (rtx, machine_mode);
extern bool mem_noofs_operand (rtx, machine_mode);
extern bool call_insn_operand (rtx, machine_mode);
extern bool aligned_operand (rtx, machine_mode);
extern bool mve_vldrd_immediate (rtx, machine_mode);
#endif /* HAVE_MACHINE_MODES */

#define CONSTRAINT_NUM_DEFINED_P 1
enum constraint_num
{
  CONSTRAINT__UNKNOWN = 0,
  CONSTRAINT_r,
  CONSTRAINT_Up,
  CONSTRAINT_Uf,
  CONSTRAINT_Te,
  CONSTRAINT_t,
  CONSTRAINT_w,
  CONSTRAINT_x,
  CONSTRAINT_y,
  CONSTRAINT_z,
  CONSTRAINT_l,
  CONSTRAINT_h,
  CONSTRAINT_k,
  CONSTRAINT_b,
  CONSTRAINT_Cs,
  CONSTRAINT_Ts,
  CONSTRAINT_Pj,
  CONSTRAINT_PJ,
  CONSTRAINT_I,
  CONSTRAINT_J,
  CONSTRAINT_K,
  CONSTRAINT_L,
  CONSTRAINT_M,
  CONSTRAINT_N,
  CONSTRAINT_O,
  CONSTRAINT_Pa,
  CONSTRAINT_Pb,
  CONSTRAINT_Pc,
  CONSTRAINT_Pd,
  CONSTRAINT_Pe,
  CONSTRAINT_Pf,
  CONSTRAINT_Pg,
  CONSTRAINT_Ps,
  CONSTRAINT_Pt,
  CONSTRAINT_Pu,
  CONSTRAINT_Pv,
  CONSTRAINT_Pw,
  CONSTRAINT_Px,
  CONSTRAINT_Py,
  CONSTRAINT_Pz,
  CONSTRAINT_m,
  CONSTRAINT_o,
  CONSTRAINT_Ul,
  CONSTRAINT_Ua,
  CONSTRAINT_Uh,
  CONSTRAINT_Ut,
  CONSTRAINT_Uv,
  CONSTRAINT_Ug,
  CONSTRAINT_Uj,
  CONSTRAINT_Uy,
  CONSTRAINT_Un,
  CONSTRAINT_Um,
  CONSTRAINT_Us,
  CONSTRAINT_Ux,
  CONSTRAINT_Uq,
  CONSTRAINT_Q,
  CONSTRAINT_Uu,
  CONSTRAINT_Uw,
  CONSTRAINT_Uz,
  CONSTRAINT_p,
  CONSTRAINT_Ri,
  CONSTRAINT_Rd,
  CONSTRAINT_Ra,
  CONSTRAINT_Rb,
  CONSTRAINT_Rc,
  CONSTRAINT_Re,
  CONSTRAINT_Rf,
  CONSTRAINT_Rg,
  CONSTRAINT_j,
  CONSTRAINT_G,
  CONSTRAINT_Ha,
  CONSTRAINT_Dz,
  CONSTRAINT_DB,
  CONSTRAINT_Da,
  CONSTRAINT_Db,
  CONSTRAINT_Dc,
  CONSTRAINT_Dd,
  CONSTRAINT_Di,
  CONSTRAINT_Dm,
  CONSTRAINT_Dn,
  CONSTRAINT_DN,
  CONSTRAINT_Dl,
  CONSTRAINT_DL,
  CONSTRAINT_Do,
  CONSTRAINT_Dv,
  CONSTRAINT_Dy,
  CONSTRAINT_Dt,
  CONSTRAINT_Ds,
  CONSTRAINT_Dp,
  CONSTRAINT_US,
  CONSTRAINT_c,
  CONSTRAINT_V,
  CONSTRAINT__l,
  CONSTRAINT__g,
  CONSTRAINT_i,
  CONSTRAINT_s,
  CONSTRAINT_n,
  CONSTRAINT_E,
  CONSTRAINT_F,
  CONSTRAINT_X,
  CONSTRAINT_Tu,
  CONSTRAINT_Ui,
  CONSTRAINT__LIMIT
};

extern enum constraint_num lookup_constraint_1 (const char *);
extern const unsigned char lookup_constraint_array[];

/* Return the constraint at the beginning of P, or CONSTRAINT__UNKNOWN if it
   isn't recognized.  */

static inline enum constraint_num
lookup_constraint (const char *p)
{
  unsigned int index = lookup_constraint_array[(unsigned char) *p];
  return (index == UCHAR_MAX
          ? lookup_constraint_1 (p)
          : (enum constraint_num) index);
}

extern bool (*constraint_satisfied_p_array[]) (rtx);

/* Return true if X satisfies constraint C.  */

static inline bool
constraint_satisfied_p (rtx x, enum constraint_num c)
{
  int i = (int) c - (int) CONSTRAINT_Pj;
  return i >= 0 && constraint_satisfied_p_array[i] (x);
}

static inline bool
insn_extra_register_constraint (enum constraint_num c)
{
  return c >= CONSTRAINT_r && c <= CONSTRAINT_Ts;
}

static inline bool
insn_extra_memory_constraint (enum constraint_num c)
{
  return c >= CONSTRAINT_m && c <= CONSTRAINT_Uz;
}

static inline bool
insn_extra_special_memory_constraint (enum constraint_num)
{
  return false;
}

static inline bool
insn_extra_relaxed_memory_constraint (enum constraint_num)
{
  return false;
}

static inline bool
insn_extra_address_constraint (enum constraint_num c)
{
  return c >= CONSTRAINT_p && c <= CONSTRAINT_p;
}

static inline void
insn_extra_constraint_allows_reg_mem (enum constraint_num c,
				      bool *allows_reg, bool *allows_mem)
{
  if (c >= CONSTRAINT_Ri && c <= CONSTRAINT_US)
    return;
  if (c >= CONSTRAINT_c && c <= CONSTRAINT_c)
    {
      *allows_reg = true;
      return;
    }
  if (c >= CONSTRAINT_V && c <= CONSTRAINT__g)
    {
      *allows_mem = true;
      return;
    }
  (void) c;
  *allows_reg = true;
  *allows_mem = true;
}

static inline size_t
insn_constraint_len (char fc, const char *str ATTRIBUTE_UNUSED)
{
  switch (fc)
    {
    case 'C': return 2;
    case 'D': return 2;
    case 'H': return 2;
    case 'P': return 2;
    case 'R': return 2;
    case 'T': return 2;
    case 'U': return 2;
    default: break;
    }
  return 1;
}

#define CONSTRAINT_LEN(c_,s_) insn_constraint_len (c_,s_)

extern enum reg_class reg_class_for_constraint_1 (enum constraint_num);

static inline enum reg_class
reg_class_for_constraint (enum constraint_num c)
{
  if (insn_extra_register_constraint (c))
    return reg_class_for_constraint_1 (c);
  return NO_REGS;
}

extern bool insn_const_int_ok_for_constraint (HOST_WIDE_INT, enum constraint_num);
#define CONST_OK_FOR_CONSTRAINT_P(v_,c_,s_) \
    insn_const_int_ok_for_constraint (v_, lookup_constraint (s_))

enum constraint_type
{
  CT_REGISTER,
  CT_CONST_INT,
  CT_MEMORY,
  CT_SPECIAL_MEMORY,
  CT_RELAXED_MEMORY,
  CT_ADDRESS,
  CT_FIXED_FORM
};

static inline enum constraint_type
get_constraint_type (enum constraint_num c)
{
  if (c >= CONSTRAINT_p)
    {
      if (c >= CONSTRAINT_Ri)
        return CT_FIXED_FORM;
      return CT_ADDRESS;
    }
  if (c >= CONSTRAINT_m)
    return CT_MEMORY;
  if (c >= CONSTRAINT_Pj)
    return CT_CONST_INT;
  return CT_REGISTER;
}
#endif /* tm-preds.h */
