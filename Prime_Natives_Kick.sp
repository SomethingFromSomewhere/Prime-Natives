#include <prime_natives>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name		= 	"[Prime Natives] Kick",
	author		= 	"Someone",
	description = 	"Kick all users without Prime status and white list access.",
	version		= 	"1.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

public void PN_OnPlayerStatusChangePost(int iClient, PRIME_STATUS iNewStatus, STATUS_CHANGE_REASON iReason)
{
	if(iNewStatus == NO_PRIME)	KickClient(iClient, "#SFUI_DisconnectReason_PrimeOnlyServer");
}
