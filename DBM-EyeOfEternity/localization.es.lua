﻿if GetLocale() ~= "esES" and GetLocale() ~= "esMX" then return end

local L

---------------
--  Malygos  --
---------------
L = DBM:GetModLocalization("Malygos")

L:SetGeneralLocalization({
	name = "Malygos"
})

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
})

L:SetMiscLocalization({
	YellPull		= "Habéis agotado mi paciencia. ¡Me desharé de vosotros!",
	EmoteSpark		= "¡Un Chispazo toma forma a partir de una falla cercana!",
	YellPhase2		= "Esperaba acabar con vuestras vidas rápidamente, pero habéis resultado más... resistentes de lo que pensaba. Aun así, vuestros esfuerzos son en vano. Esta guerra es culpa vuestra, imprudentes mortales descuidados. Yo hago lo que debo... y si eso implica vuestra extinción... ¡QUE ASÍ SEA!",
	YellBreath		= "¡No lo conseguiréis mientras me quede aliento!",
	YellPhase3		= "Ahora aparecen vuestros benefactores, ¡pero llegan demasiado tarde! Los poderes aquí contenidos son suficientes para destruir el mundo diez veces. ¿Qué creéis que os harán a vosotros?"
})
