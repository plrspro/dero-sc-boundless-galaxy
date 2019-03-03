/*

	`Boundless Galaxy`
	
	General notes:
	none

*/

/*

	Technical notes:
	1. The UInt64 value type represents unsigned integers with values ranging from 0 to 18,446,744,073,709,551,615. 
	2. Galaxy limitations obstructed for simplicity equalst to values ranging from 0 to 10 000 000 000 000 000 000

*/

/* Service Functions and Utility */

Function Info(info_message String) Uint64 

	01 DIM txid as String
	02 LET txid = TXID()

	10  PRINTF "  +-------------------+  " 
	20  PRINTF "  |  `DERO  Galaxy    |  " 
	30  PRINTF "  |                   |  " 
	40  PRINTF "  | %s" info_message
	50  PRINTF "  |                   |  " 
	60  PRINTF "  +-------------------+  " 
	70  PRINTF "  + TXID: %s" txid
	80  PRINTF "  +-------------------+  " 
	
	999 RETURN 0
End Function 


Function Error(error_message String) Uint64 

	01 DIM txid as String
	02 LET txid = TXID()

	10  PRINTF "  +-----[ ERROR ]-----+  " 
	20  PRINTF "  |  `DERO  Galaxy    |  " 
	30  PRINTF "  |                   |  " 
	40  PRINTF "  | %s" error_message
	50  PRINTF "  |                   |  " 
	60  PRINTF "  +-----[ ERROR ]-----+  " 
	70  PRINTF "  + TXID: %s" txid
	80  PRINTF "  +-------------------+  " 
	
	999 RETURN 1
End Function 


Function Initialize() Uint64
	
	// Galaxy center is
	
	10 STORE("admin", SIGNER())   // store in DB  ["owner"] = address
	
	20 PlanetAcquire(10000000000000000000/2, 10000000000000000000/2, 5)
	
	999 RETURN Info("Contract Successfully Deployed")
End Function 


/* Owner & Administrative Functions */

Function AdminTransferOwnership(new_admin String) Uint64 

	10  IF ADDRESS_RAW(LOAD("admin")) == ADDRESS_RAW(SIGNER()) THEN GOTO 20 
	11  RETURN 1
	
	20  STORE("swap", new_admin)
	21  RETURN 0
	
End Function
	
	
// until the new owner claims ownership, existing owner remains owner
Function AdminClaimOwnership() Uint64 

	10  IF ADDRESS_RAW(LOAD("swap")) == ADDRESS_RAW(SIGNER()) THEN GOTO 20 
	11  RETURN 1
	
	20  STORE("admin", SIGNER()) // ownership claim successful
	21  RETURN 0
	
End Function
	
	
// if signer is owner, withdraw any requested funds
// if everthing is okay, thety will be showing in signers wallet
Function AdminWithdraw(amount Uint64) Uint64 

	10  IF ADDRESS_RAW(LOAD("admin")) == ADDRESS_RAW(SIGNER()) THEN GOTO 20 
	11  RETURN 1
	
	20  SEND_DERO_TO_ADDRESS(SIGNER(), amount)
	21  RETURN 0
	
End Function


/* Contract Core Functions */

Function PlanetAcquire(position_x Uint64, position_y Uint64, position_z Uint64) Uint64

	// >= 0 && <= 10000000000000000000 (positions of x, y)
	// 00 01 02 03 04 05 06 07 [08] 09 10 11 12 13 14 15 16 (positions of z)
	
	// Initialize user stack if its his 1st platform
	10 DIM user as String
	11 DIM stack_index as Uint64
	12 LET user = SIGNER()
	13 LET stack_index = 0
	
	20 IF EXISTS(user+"_index") == 1 THEN GOTO 30
	21 STORE(user+"_index", stack_index)
	
	30 LET stack_index = LOAD(user+"_index")
	
	/*
    setoff.RARECloudiness = 1; // 0-100
    setoff.RARECold = 1; // 0-100
    setoff.RAREOcean = 1; // 0-100
    setoff.RARETemperate = 1; // 0-100
    setoff.RAREWarm = 1; // 0-100
    setoff.RAREHot = 1; // 0-100
    setoff.RARESpeckle = 1; // 0-100
    setoff.RAREClouds = 1; // 0-100
    setoff.RARELightColor = 1; // 0-100

    setoff.vWaterLevel = 0; // 0-40
    setoff.vRivers = 0; // 0-100
    setoff.vTemperature = 0; // 0-40
    setoff.vCloudiness = 0; // 0-20

    setoff.vCold_r = 44; // 0-100
    setoff.vCold_g = 13; // 0-100
    setoff.vCold_b = 14; // 0-100

    setoff.vOcean_r = 17; // 0-100
    setoff.vOcean_g = 18; // 0-100
    setoff.vOcean_b = 19; // 0-100

    setoff.vTemperate_r = 60; // 0-100
    setoff.vTemperate_g = 70; // 0-100
    setoff.vTemperate_b = 10; // 0-100

    setoff.vWarm_r = 60; // 0-100
    setoff.vWarm_g = 60; // 0-100
    setoff.vWarm_b = 60; // 0-100

    setoff.vHot_r = 60; // 0-100
    setoff.vHot_g = 60; // 0-100
    setoff.vHot_b = 60; // 0-100

    setoff.vSpeckle_r = 60; // 0-100
    setoff.vSpeckle_g = 60; // 0-100
    setoff.vSpeckle_b = 60; // 0-100

    setoff.vClouds_r = 60; // 0-100
    setoff.vClouds_g = 60; // 0-100
    setoff.vClouds_b = 60; // 0-100

    setoff.vLightColor_r = 60; // 0-100
    setoff.vLightColor_g = 60; // 0-100
    setoff.vLightColor_b = 60; // 0-100

    setoff.vHaze_r = 60; // 0-100
    setoff.vHaze_g = 60; // 0-100
    setoff.vHaze_b = 60; // 0-100

    setoff.fixtures01 = 10; // 0-20
    setoff.fixtures02 = 30; // 0-100
    setoff.fixtures03 = 50; // 0-100
    setoff.fixtures04 = 0; // 0-10
    setoff.fixtures05 = 0; // 0-7
    setoff.fixtures06 = 110; // 0-220
    setoff.fixtures07 = 40; // 0-80
    setoff.fixtures08 = 5; // 0-9
    setoff.fixtures09 = 7; // 0-20

    setoff.vAngle = 0; // 0-60
    setoff.vRotspeed = 0; // 0-20
	*/
	
	// All checkup passed now we can generate planet
	100 STORE("["+position_x+":"+position_y+":"+position_z+"]/Owner", 			SIGNER())
	
	101 STORE("["+position_x+":"+position_y+":"+position_z+"]/RARECloudiness",  0 + RANDOM(100 + 1) )
	102 STORE("["+position_x+":"+position_y+":"+position_z+"]/RARECold", 		0 + RANDOM(100 + 1) )
	103 STORE("["+position_x+":"+position_y+":"+position_z+"]/RAREOcean", 		0 + RANDOM(100 + 1) )
	104 STORE("["+position_x+":"+position_y+":"+position_z+"]/RARETemperate", 	0 + RANDOM(100 + 1) )
	105 STORE("["+position_x+":"+position_y+":"+position_z+"]/RAREWarm", 		0 + RANDOM(100 + 1) )
	106 STORE("["+position_x+":"+position_y+":"+position_z+"]/RAREHot", 		0 + RANDOM(100 + 1) )
	107 STORE("["+position_x+":"+position_y+":"+position_z+"]/RARESpeckle", 	0 + RANDOM(100 + 1) )
	108 STORE("["+position_x+":"+position_y+":"+position_z+"]/RAREClouds", 		0 + RANDOM(100 + 1) )
	109 STORE("["+position_x+":"+position_y+":"+position_z+"]/RARELightColor", 	0 + RANDOM(100 + 1) )
	
	110 STORE("["+position_x+":"+position_y+":"+position_z+"]/Speed", SIGNER())
	111 STORE("["+position_x+":"+position_y+":"+position_z+"]/Direction", SIGNER())
	
	200 STORE(user+"_index_"+stack_index, "["+position_x+":"+position_y+":"+position_z+"]")
	201 STORE(user+"_index", stack_index + 1)
	
	300 RETURN 0
	
End Function

/*
Function PlanetMerge(planet1_x Uint64, planet1_y Uint64, planet1_z Uint64, planet2_x Uint64, planet2_y Uint64, planet2_z Uint64)

End Function


Function PlanetSetNote(position_x Uint64, position_y Uint64, position_z Uint64, note String) Uint64

	10 IF EXISTS("["+position_x+":"+position_y+":"+position_z+"] - Owner") == 1 THEN GOTO 20
	
	
	11 IF ADDRESS_RAW(LOAD("["+position_x+":"+position_y+":"+position_z+"] - Owner")) == ADDRESS_RAW(SIGNER()) THEN GOTO
	
	
	100 STORE("["+position_x+":"+position_y+":"+position_z+"] - Note", note)

End Function


Function PlanetSellOut()

End Function


Function PlanetBuyIn()

End Function
*/
