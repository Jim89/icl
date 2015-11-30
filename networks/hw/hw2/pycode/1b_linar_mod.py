# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
# %%
from pulp import *

# define variables
x_sa = LpVariable("x_sa", 0, 5)
x_sb = LpVariable("x_sb", 0, 3)
x_sc = LpVariable("x_sc", 0, 13)

x_ad = LpVariable("x_ad", 0, 3)
x_be = LpVariable("x_be", 0, 4)

x_ca = LpVariable("x_ca", 0, 7)
x_cb = LpVariable("x_cb", 0, 5)
x_cd = LpVariable("x_cd", 0, 2)
x_ce = LpVariable("x_ce", 0, 2)

x_dt = LpVariable("x_dt", 0, 10)

x_ed = LpVariable("x_ed", 0, 9)
x_et = LpVariable("x_dt", 0, 10)

 
