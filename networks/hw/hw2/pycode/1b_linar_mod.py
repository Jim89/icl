# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
# %%
from pulp import *

# define variables
x_sa = LpVariable("x_sa", 0, 5, LpInteger)
x_sb = LpVariable("x_sb", 0, 3, LpInteger)
x_sc = LpVariable("x_sc", 0, 13, LpInteger)

x_ad = LpVariable("x_ad", 0, 3, LpInteger)
x_be = LpVariable("x_be", 0, 4, LpInteger)

x_ca = LpVariable("x_ca", 0, 7, LpInteger)
x_cb = LpVariable("x_cb", 0, 5, LpInteger)
x_cd = LpVariable("x_cd", 0, 2, LpInteger)
x_ce = LpVariable("x_ce", 0, 2, LpInteger)

x_dt = LpVariable("x_dt", 0, 10, LpInteger)

x_ed = LpVariable("x_ed", 0, 9, LpInteger)
x_et = LpVariable("x_et", 0, 10, LpInteger)

f = LpVariable("f", 0, float('inf'), LpInteger)

# define the problem
prob = LpProblem("problem", LpMaximize)

# define constraints
prob += x_sa + x_sb + x_sc -f == 0
prob += x_ad - x_sa - x_ca == 0
prob += x_be - x_sb - x_cb == 0
prob += x_ca + x_cb + x_cd + x_ce - x_sc == 0
prob += x_dt - x_ad - x_cd - x_ed == 0
prob += x_ed - x_be - x_ce == 0
prob += -1*x_dt - x_et + f == 0

# define function to maximise
prob += f

# %%
LpSolverDefault.msg = 1
status = prob.solve(GLPK_CMD())

 
