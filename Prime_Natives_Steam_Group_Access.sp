#include <prime_natives>
#include <SWGM>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name		= "[Prime Natives] Steam Group Access",
	author		= "Someone",
	description = "Provides access for users without Prime who joined steam group.",
	version		= "1.0",
	url			= "https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

bool g_bOfficerOnly;

public void OnPluginStart()
{
	ConVar CVAR;
	(CVAR = CreateConVar("sm_prime_natives_swgm_type",		"1",	"Настройка доступа: 1 - все пользователи. | 0 - только администрация и модераторы.")).AddChangeHook(OnTypeChange);
	g_bOfficerOnly = CVAR.BoolValue;
	AutoExecConfig(true, "steam_group_access", "sourcemod/prime_natives");
}

public void OnTypeChange(ConVar CVAR, const char[] oldValue, const char[] newValue)
{
	g_bOfficerOnly = CVAR.BoolValue;
}

public void SWGM_OnJoinGroup(int iClient, bool bIsOfficer)
{
	static PRIME_STATUS iStatus;
	iStatus = PN_GetPlayerStatus(iClient);
	if(iStatus == NO_PRIME && ((!g_bOfficerOnly && SWGM_InGroupOfficer(iClient)) || SWGM_InGroup(iClient)))
	{
		PN_SetPlayerStatus(iClient, WHITE_LIST);
	}
}

public void SWGM_OnLeaveGroup(int iClient)
{
	PN_ForcePlayerCheck(iClient, WHITE_LIST_REMOVE);
}

public Action PN_OnPlayerStatusChange(int iClient, PRIME_STATUS &iNewStatus, STATUS_CHANGE_REASON iReason)
{
	if(iNewStatus == NO_PRIME)
	{
		static Status iGroupStatus;
		iGroupStatus = SWGM_GetPlayerStatus(iClient);
		if((!g_bOfficerOnly && iGroupStatus == OFFICER) || (iGroupStatus > LEAVER))
		{
			iNewStatus = WHITE_LIST;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}