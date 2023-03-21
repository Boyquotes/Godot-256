extends Node

func bb_length(word=""):
	if "[" in word:
		var nr=0
		var ignore=false
		for i in word.length():
			if not ignore:
				nr+=1
				if word[i]=="[":
					ignore=true
			elif word[i]=="]":
				ignore=false
		return nr
	else:
		return word.length()


var number_0 = preload("res://06_resources/Fonts/Alfabeth/0.png")
var number_1 = preload("res://06_resources/Fonts/Alfabeth/1.png")
var number_2 = preload("res://06_resources/Fonts/Alfabeth/2.png")
var number_3 = preload("res://06_resources/Fonts/Alfabeth/3.png")
var number_4 = preload("res://06_resources/Fonts/Alfabeth/4.png")
var number_5 = preload("res://06_resources/Fonts/Alfabeth/5.png")
var number_6 = preload("res://06_resources/Fonts/Alfabeth/6.png")
var number_7 = preload("res://06_resources/Fonts/Alfabeth/7.png")
var number_8 = preload("res://06_resources/Fonts/Alfabeth/8.png")
var number_9 = preload("res://06_resources/Fonts/Alfabeth/9.png")
var letter_A = preload("res://06_resources/Fonts/Alfabeth/A.png")
var letter_B = preload("res://06_resources/Fonts/Alfabeth/B.png")
var letter_C = preload("res://06_resources/Fonts/Alfabeth/C.png")
var letter_D = preload("res://06_resources/Fonts/Alfabeth/D.png")
var letter_E = preload("res://06_resources/Fonts/Alfabeth/E.png")
var letter_F = preload("res://06_resources/Fonts/Alfabeth/F.png")
var letter_G = preload("res://06_resources/Fonts/Alfabeth/G.png")
var letter_H = preload("res://06_resources/Fonts/Alfabeth/H.png")
var letter_I = preload("res://06_resources/Fonts/Alfabeth/I.png")
var letter_J = preload("res://06_resources/Fonts/Alfabeth/J.png")
var letter_K = preload("res://06_resources/Fonts/Alfabeth/K.png")
var letter_L = preload("res://06_resources/Fonts/Alfabeth/L.png")
var letter_M = preload("res://06_resources/Fonts/Alfabeth/M.png")
var letter_N = preload("res://06_resources/Fonts/Alfabeth/N.png")
var letter_O = preload("res://06_resources/Fonts/Alfabeth/O.png")
var letter_P = preload("res://06_resources/Fonts/Alfabeth/P.png")
var letter_Q = preload("res://06_resources/Fonts/Alfabeth/Q.png")
var letter_R = preload("res://06_resources/Fonts/Alfabeth/R.png")
var letter_S = preload("res://06_resources/Fonts/Alfabeth/S.png")
var letter_T = preload("res://06_resources/Fonts/Alfabeth/T.png")
var letter_U = preload("res://06_resources/Fonts/Alfabeth/U.png")
var letter_V = preload("res://06_resources/Fonts/Alfabeth/V.png")
var letter_W = preload("res://06_resources/Fonts/Alfabeth/W.png")
var letter_X = preload("res://06_resources/Fonts/Alfabeth/X.png")
var letter_Y = preload("res://06_resources/Fonts/Alfabeth/Y.png")
var letter_Z = preload("res://06_resources/Fonts/Alfabeth/Z.png")

var letter_a = preload("res://06_resources/Fonts/Alfabeth/a_small.png")
var letter_b = preload("res://06_resources/Fonts/Alfabeth/b_small.png")
var letter_c = preload("res://06_resources/Fonts/Alfabeth/c_small.png")
var letter_d = preload("res://06_resources/Fonts/Alfabeth/d_small.png")
var letter_e = preload("res://06_resources/Fonts/Alfabeth/e_small.png")
var letter_f = preload("res://06_resources/Fonts/Alfabeth/f_small.png")
var letter_g = preload("res://06_resources/Fonts/Alfabeth/g_small.png")
var letter_h = preload("res://06_resources/Fonts/Alfabeth/h_small.png")
var letter_i = preload("res://06_resources/Fonts/Alfabeth/i_small.png")
var letter_j = preload("res://06_resources/Fonts/Alfabeth/j_small.png")
var letter_k = preload("res://06_resources/Fonts/Alfabeth/k_small.png")
var letter_l = preload("res://06_resources/Fonts/Alfabeth/l_small.png")
var letter_m = preload("res://06_resources/Fonts/Alfabeth/m_small.png")
var letter_n = preload("res://06_resources/Fonts/Alfabeth/n_small.png")
var letter_o = preload("res://06_resources/Fonts/Alfabeth/o_small.png")
var letter_p = preload("res://06_resources/Fonts/Alfabeth/p_small.png")
var letter_q = preload("res://06_resources/Fonts/Alfabeth/q_small.png")
var letter_r = preload("res://06_resources/Fonts/Alfabeth/r_small.png")
var letter_s = preload("res://06_resources/Fonts/Alfabeth/s_small.png")
var letter_t = preload("res://06_resources/Fonts/Alfabeth/t_small.png")
var letter_u = preload("res://06_resources/Fonts/Alfabeth/u_small.png")
var letter_v = preload("res://06_resources/Fonts/Alfabeth/v_small.png")
var letter_w = preload("res://06_resources/Fonts/Alfabeth/w_small.png")
var letter_x = preload("res://06_resources/Fonts/Alfabeth/x_small.png")
var letter_y = preload("res://06_resources/Fonts/Alfabeth/y_small.png")
var letter_z = preload("res://06_resources/Fonts/Alfabeth/z_small.png")


var letter_empty = preload("res://06_resources/Fonts/Special_Objects/Z00_EMPTY.png")

var colon = preload("res://06_resources/Fonts/Special_Objects/Z01_dwukropek.png")
var pause = preload("res://06_resources/Fonts/Special_Objects/Z02_PAUSA.png")
var question_mark = preload("res://06_resources/Fonts/Special_Objects/Z03_pytajnik.png")
var dot = preload("res://06_resources/Fonts/Special_Objects/Z04_kropka.png")
var exclamation = preload("res://06_resources/Fonts/Special_Objects/Z05_wykrzyknik.png")
var comma = preload("res://06_resources/Fonts/Special_Objects/Z06_przecinek.png")
var apostrophe = preload("res://06_resources/Fonts/Special_Objects/Z07_apostrof.png")
var dash = preload("res://06_resources/Fonts/Special_Objects/Z08_MYSLNIK.png")
var greater = preload("res://06_resources/Fonts/Special_Objects/Z09_WIEKSZY.png")
var lesser = preload("res://06_resources/Fonts/Special_Objects/Z10_MNIEJSZY.png")
var slash_to_left = preload("res://06_resources/Fonts/Special_Objects/Z11_slash_w_lewo.png")
var hash_mark = preload("res://06_resources/Fonts/Special_Objects/Z12_hash.png")
var percent = preload("res://06_resources/Fonts/Special_Objects/Z13_procent.png")




########### CZ ##############
var number_of_CZ_letters=15
var cz_001=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.001.png")
var cz_002=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.002.png")
var cz_003=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.003.png")
var cz_004=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.004.png")
var cz_005=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.005.png")
var cz_006=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.006.png")
var cz_007=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.007.png")
var cz_008=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.008.png")
var cz_009=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.009.png")
var cz_010=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.010.png")
var cz_011=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.011.png")
var cz_012=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.012.png")
var cz_013=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.013.png")
var cz_014=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.014.png")
var cz_015=preload("res://06_resources/Fonts/CZ_Alfabeth/CZ.015.png")

########### DE ##############
var number_of_DE_letters=4
var de_001=preload("res://06_resources/Fonts/DE_Alfabeth/DE.001.png")
var de_002=preload("res://06_resources/Fonts/DE_Alfabeth/DE.002.png")
var de_003=preload("res://06_resources/Fonts/DE_Alfabeth/DE.003.png")
var de_004=preload("res://06_resources/Fonts/DE_Alfabeth/DE.004.png")

########### DK ##############
var number_of_DK_letters=3
var dk_001=preload("res://06_resources/Fonts/DK_Alfabeth/DK.001.png")
var dk_002=preload("res://06_resources/Fonts/DK_Alfabeth/DK.002.png")
var dk_003=preload("res://06_resources/Fonts/DK_Alfabeth/DK.003.png")

########### EE ##############
var number_of_EE_letters=6
var ee_001=preload("res://06_resources/Fonts/EE_Alfabeth/EE.001.png")
var ee_002=preload("res://06_resources/Fonts/EE_Alfabeth/EE.002.png")
var ee_003=preload("res://06_resources/Fonts/EE_Alfabeth/EE.003.png")
var ee_004=preload("res://06_resources/Fonts/EE_Alfabeth/EE.004.png")
var ee_005=preload("res://06_resources/Fonts/EE_Alfabeth/EE.005.png")
var ee_006=preload("res://06_resources/Fonts/EE_Alfabeth/EE.006.png")

########### ESP ##############
var number_of_ESP_letters=1
var esp_001=preload("res://06_resources/Fonts/ESP_Alfabeth/ESP.001.png")

########### FI ##############
var number_of_FI_letters=4
var fi_001=preload("res://06_resources/Fonts/FI_Alfabeth/FI.001.png")
var fi_002=preload("res://06_resources/Fonts/FI_Alfabeth/FI.002.png")
var fi_003=preload("res://06_resources/Fonts/FI_Alfabeth/FI.003.png")
var fi_004=preload("res://06_resources/Fonts/FI_Alfabeth/FI.004.png")

########### FR ##############
var number_of_FR_letters=19
var fr_001=preload("res://06_resources/Fonts/FR_Alfabeth/FR.001.png")
var fr_002=preload("res://06_resources/Fonts/FR_Alfabeth/FR.002.png")
var fr_003=preload("res://06_resources/Fonts/FR_Alfabeth/FR.003.png")
var fr_004=preload("res://06_resources/Fonts/FR_Alfabeth/FR.004.png")
var fr_005=preload("res://06_resources/Fonts/FR_Alfabeth/FR.005.png")
var fr_006=preload("res://06_resources/Fonts/FR_Alfabeth/FR.006.png")
var fr_007=preload("res://06_resources/Fonts/FR_Alfabeth/FR.007.png")
var fr_008=preload("res://06_resources/Fonts/FR_Alfabeth/FR.008.png")
var fr_009=preload("res://06_resources/Fonts/FR_Alfabeth/FR.009.png")
var fr_010=preload("res://06_resources/Fonts/FR_Alfabeth/FR.010.png")
var fr_011=preload("res://06_resources/Fonts/FR_Alfabeth/FR.011.png")
var fr_012=preload("res://06_resources/Fonts/FR_Alfabeth/FR.012.png")
var fr_013=preload("res://06_resources/Fonts/FR_Alfabeth/FR.013.png")
var fr_014=preload("res://06_resources/Fonts/FR_Alfabeth/FR.014.png")
var fr_015=preload("res://06_resources/Fonts/FR_Alfabeth/FR.015.png")
var fr_016=preload("res://06_resources/Fonts/FR_Alfabeth/FR.016.png")
var fr_017=preload("res://06_resources/Fonts/FR_Alfabeth/FR.017.png")
var fr_018=preload("res://06_resources/Fonts/FR_Alfabeth/FR.018.png")
var fr_019=preload("res://06_resources/Fonts/FR_Alfabeth/FR.019.png")

########### HR ##############
var number_of_HR_letters=4
var hr_001=preload("res://06_resources/Fonts/HR_Alfabeth/HR.001.png")
var hr_002=preload("res://06_resources/Fonts/HR_Alfabeth/HR.002.png")
var hr_003=preload("res://06_resources/Fonts/HR_Alfabeth/HR.003.png")
var hr_004=preload("res://06_resources/Fonts/HR_Alfabeth/HR.004.png")
var hr_005=preload("res://06_resources/Fonts/HR_Alfabeth/HR.005.png")


########### HU ##############
var number_of_HU_letters=9
var hu_001=preload("res://06_resources/Fonts/HU_Alfabeth/HU.001.png")
var hu_002=preload("res://06_resources/Fonts/HU_Alfabeth/HU.002.png")
var hu_003=preload("res://06_resources/Fonts/HU_Alfabeth/HU.003.png")
var hu_004=preload("res://06_resources/Fonts/HU_Alfabeth/HU.004.png")
var hu_005=preload("res://06_resources/Fonts/HU_Alfabeth/HU.005.png")
var hu_006=preload("res://06_resources/Fonts/HU_Alfabeth/HU.006.png")
var hu_007=preload("res://06_resources/Fonts/HU_Alfabeth/HU.007.png")
var hu_008=preload("res://06_resources/Fonts/HU_Alfabeth/HU.008.png")
var hu_009=preload("res://06_resources/Fonts/HU_Alfabeth/HU.009.png")

########### LT ##############
var number_of_LT_letters=9
var lt_001=preload("res://06_resources/Fonts/LT_Alfabeth/LT.001.png")
var lt_002=preload("res://06_resources/Fonts/LT_Alfabeth/LT.002.png")
var lt_003=preload("res://06_resources/Fonts/LT_Alfabeth/LT.003.png")
var lt_004=preload("res://06_resources/Fonts/LT_Alfabeth/LT.004.png")
var lt_005=preload("res://06_resources/Fonts/LT_Alfabeth/LT.005.png")
var lt_006=preload("res://06_resources/Fonts/LT_Alfabeth/LT.006.png")
var lt_007=preload("res://06_resources/Fonts/LT_Alfabeth/LT.007.png")
var lt_008=preload("res://06_resources/Fonts/LT_Alfabeth/LT.008.png")
var lt_009=preload("res://06_resources/Fonts/LT_Alfabeth/LT.009.png")

########### LV ##############
var number_of_LV_letters=7
var lv_001=preload("res://06_resources/Fonts/LV_Alfabeth/LV.001.png")
var lv_002=preload("res://06_resources/Fonts/LV_Alfabeth/LV.002.png")
var lv_003=preload("res://06_resources/Fonts/LV_Alfabeth/LV.003.png")
var lv_004=preload("res://06_resources/Fonts/LV_Alfabeth/LV.004.png")
var lv_005=preload("res://06_resources/Fonts/LV_Alfabeth/LV.005.png")
var lv_006=preload("res://06_resources/Fonts/LV_Alfabeth/LV.006.png")
var lv_007=preload("res://06_resources/Fonts/LV_Alfabeth/LV.007.png")

########### PL ##############
var number_of_PL_letters=9
var pl_001=preload("res://06_resources/Fonts/PL_Alfabeth/PL.001.png")
var pl_002=preload("res://06_resources/Fonts/PL_Alfabeth/PL.002.png")
var pl_003=preload("res://06_resources/Fonts/PL_Alfabeth/PL.003.png")
var pl_004=preload("res://06_resources/Fonts/PL_Alfabeth/PL.004.png")
var pl_005=preload("res://06_resources/Fonts/PL_Alfabeth/PL.005.png")
var pl_006=preload("res://06_resources/Fonts/PL_Alfabeth/PL.006.png")
var pl_007=preload("res://06_resources/Fonts/PL_Alfabeth/PL.007.png")
var pl_008=preload("res://06_resources/Fonts/PL_Alfabeth/PL.008.png")
var pl_009=preload("res://06_resources/Fonts/PL_Alfabeth/PL.009.png")

########### PT ##############
var number_of_PT_letters=13
var pt_001=preload("res://06_resources/Fonts/PT_Alfabeth/PT.001.png")
var pt_002=preload("res://06_resources/Fonts/PT_Alfabeth/PT.002.png")
var pt_003=preload("res://06_resources/Fonts/PT_Alfabeth/PT.003.png")
var pt_004=preload("res://06_resources/Fonts/PT_Alfabeth/PT.004.png")
var pt_005=preload("res://06_resources/Fonts/PT_Alfabeth/PT.005.png")
var pt_006=preload("res://06_resources/Fonts/PT_Alfabeth/PT.006.png")
var pt_007=preload("res://06_resources/Fonts/PT_Alfabeth/PT.007.png")
var pt_008=preload("res://06_resources/Fonts/PT_Alfabeth/PT.008.png")
var pt_009=preload("res://06_resources/Fonts/PT_Alfabeth/PT.009.png")
var pt_010=preload("res://06_resources/Fonts/PT_Alfabeth/PT.010.png")
var pt_011=preload("res://06_resources/Fonts/PT_Alfabeth/PT.011.png")
var pt_012=preload("res://06_resources/Fonts/PT_Alfabeth/PT.012.png")
var pt_013=preload("res://06_resources/Fonts/PT_Alfabeth/PT.013.png")

########### RO ##############
var number_of_RO_letters=5
var ro_001=preload("res://06_resources/Fonts/RO_Alfabeth/RO.001.png")
var ro_002=preload("res://06_resources/Fonts/RO_Alfabeth/RO.002.png")
var ro_003=preload("res://06_resources/Fonts/RO_Alfabeth/RO.003.png")
var ro_004=preload("res://06_resources/Fonts/RO_Alfabeth/RO.004.png")
var ro_005=preload("res://06_resources/Fonts/RO_Alfabeth/RO.005.png")

########### SE ##############
var number_of_SE_letters=3
var se_001=preload("res://06_resources/Fonts/SE_Alfabeth/SE.001.png")
var se_002=preload("res://06_resources/Fonts/SE_Alfabeth/SE.002.png")
var se_003=preload("res://06_resources/Fonts/SE_Alfabeth/SE.003.png")

########### SK ##############
var number_of_SK_letters=16
var sk_001=preload("res://06_resources/Fonts/SK_Alfabeth/SK.001.png")
var sk_002=preload("res://06_resources/Fonts/SK_Alfabeth/SK.002.png")
var sk_003=preload("res://06_resources/Fonts/SK_Alfabeth/SK.003.png")
var sk_004=preload("res://06_resources/Fonts/SK_Alfabeth/SK.004.png")
var sk_005=preload("res://06_resources/Fonts/SK_Alfabeth/SK.005.png")
var sk_006=preload("res://06_resources/Fonts/SK_Alfabeth/SK.006.png")
var sk_007=preload("res://06_resources/Fonts/SK_Alfabeth/SK.007.png")
var sk_008=preload("res://06_resources/Fonts/SK_Alfabeth/SK.008.png")
var sk_009=preload("res://06_resources/Fonts/SK_Alfabeth/SK.009.png")
var sk_010=preload("res://06_resources/Fonts/SK_Alfabeth/SK.010.png")
var sk_011=preload("res://06_resources/Fonts/SK_Alfabeth/SK.011.png")
var sk_012=preload("res://06_resources/Fonts/SK_Alfabeth/SK.012.png")
var sk_013=preload("res://06_resources/Fonts/SK_Alfabeth/SK.013.png")
var sk_014=preload("res://06_resources/Fonts/SK_Alfabeth/SK.014.png")
var sk_015=preload("res://06_resources/Fonts/SK_Alfabeth/SK.015.png")
var sk_016=preload("res://06_resources/Fonts/SK_Alfabeth/SK.016.png")

########### SL ##############
var number_of_SL_letters=16
var sl_001=preload("res://06_resources/Fonts/SL_Alfabeth/SL.001.png")
var sl_002=preload("res://06_resources/Fonts/SL_Alfabeth/SL.002.png")
var sl_003=preload("res://06_resources/Fonts/SL_Alfabeth/SL.003.png")
var sl_004=preload("res://06_resources/Fonts/SL_Alfabeth/SL.004.png")
var sl_005=preload("res://06_resources/Fonts/SL_Alfabeth/SL.005.png")
var sl_006=preload("res://06_resources/Fonts/SL_Alfabeth/SL.006.png")
var sl_007=preload("res://06_resources/Fonts/SL_Alfabeth/SL.007.png")
var sl_008=preload("res://06_resources/Fonts/SL_Alfabeth/SL.008.png")
var sl_009=preload("res://06_resources/Fonts/SL_Alfabeth/SL.009.png")
var sl_010=preload("res://06_resources/Fonts/SL_Alfabeth/SL.010.png")
var sl_011=preload("res://06_resources/Fonts/SL_Alfabeth/SL.011.png")
var sl_012=preload("res://06_resources/Fonts/SL_Alfabeth/SL.012.png")
var sl_013=preload("res://06_resources/Fonts/SL_Alfabeth/SL.013.png")
var sl_014=preload("res://06_resources/Fonts/SL_Alfabeth/SL.014.png")
var sl_015=preload("res://06_resources/Fonts/SL_Alfabeth/SL.015.png")
var sl_016=preload("res://06_resources/Fonts/SL_Alfabeth/SL.016.png")

########### TR ##############
var number_of_TR_letters=4
var tr_001=preload("res://06_resources/Fonts/TR_Alfabeth/TR.001.png")
var tr_002=preload("res://06_resources/Fonts/TR_Alfabeth/TR.002.png")
var tr_003=preload("res://06_resources/Fonts/TR_Alfabeth/TR.003.png")
var tr_004=preload("res://06_resources/Fonts/TR_Alfabeth/TR.004.png")

