-- /SBA: Program Details =======================================================
-- Program: 
-- Version:
-- Date:
-- Author:
-- Description:
-- /SBA: End Program Details ---------------------------------------------------

-- /SBA: User Registers and Constants ==========================================

-- /SBA: End User Registers and Constants --------------------------------------

-- /SBA: User Program ==========================================================

=> SBAjump(Init);            -- Reset Vector (001)
=> SBAjump(INT);             -- Interrupt Vector (002)

------------------------------ ROUTINES ----------------------------------------

------------------------------ INTERRUPT ---------------------------------------
-- /L:INT
=> SBAWait;                  -- Start your interrupt routine here
=> SBAreti;
------------------------------ MAIN PROGRAM ------------------------------------

-- /L:Init
=> SBAWait;                  -- Start your program here
=> SBAjump(Init);

-- /SBA: End User Program ------------------------------------------------------
