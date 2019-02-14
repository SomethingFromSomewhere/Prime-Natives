#include <prime_natives>
#include <SteamWorks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name		= 	"Prime Natives",
	author		= 	"Someone",
	version		= 	"1.0.0",
	description =	"Provides feautres for check player Prime status",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

bool g_bLoaded[MAXPLAYERS+1];
PRIME_STATUS g_iStatus[MAXPLAYERS+1];
Handle g_hForward_OnPlayerAuthorized, g_hForward_OnStatusChange, g_hForward_OnStatusChangePost;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_hForward_OnPlayerAuthorized 	= 	CreateGlobalForward("PN_OnPlayerAuthorized", 			ET_Ignore, 		Param_Cell, 	Param_CellByRef					);
	g_hForward_OnStatusChange 		= 	CreateGlobalForward("PN_OnPlayerStatusChange", 			ET_Event, 		Param_Cell, 	Param_CellByRef, 	Param_Cell	);
	g_hForward_OnStatusChangePost 	= 	CreateGlobalForward("PN_OnPlayerStatusChangePost", 		ET_Ignore, 		Param_Cell, 	Param_Cell, 		Param_Cell	);
	
	CreateNative("PN_GetPlayerStatus", 	Native_GetPlayerStatus);
	CreateNative("PN_SetPlayerStatus", 	Native_SetPlayerStatus);
	CreateNative("PN_ForcePlayerCheck", Native_ForcePlayerCheck);
	
	RegPluginLibrary("prime_natives");
	
	return APLRes_Success;
}

public int Native_GetPlayerStatus(Handle hPlugin, int iClient)
{
	return CheckClient((iClient = GetNativeCell(1)), "GetPlayerStatus", false) ? view_as<int>(g_iStatus[iClient]):-1;
}

public int Native_SetPlayerStatus(Handle hPlugin, int iClient)
{
	return CheckClient((iClient = GetNativeCell(1)), "SetPlayerStatus") ? view_as<int>(OnStatusChange(iClient, GetNativeCell(2), GetNativeCell(3))):-1;
}

public int Native_ForcePlayerCheck(Handle hPlugin, int iClient)
{
	return CheckClient((iClient = GetNativeCell(1)), "ForcePlayerCheck") ? view_as<int>(OnStatusChange(iClient, view_as<PRIME_STATUS>(SteamWorks_HasLicenseForAppId(GetSteamAccountID(iClient), 624820)), GetNativeCell(2))):-1;
}

public int SteamWorks_OnValidateClient(int iOwnerAuthID, int iAccountID)
{
	if((iOwnerAuthID = GetClientFromAccountId(iAccountID)) != -1)
	{
		g_bLoaded[iOwnerAuthID] = true;
		OnStatusChange(iOwnerAuthID, view_as<PRIME_STATUS>(SteamWorks_HasLicenseForAppId(iAccountID, 624820)), PLAYER_LOAD);
		Call_StartForward(g_hForward_OnPlayerAuthorized);
		Call_PushCell(iOwnerAuthID);
		Call_PushCellRef(g_iStatus[iOwnerAuthID]);
		
		Call_Finish();
	}
}

PRIME_STATUS OnStatusChange(int iClient, PRIME_STATUS iNewStatus, STATUS_CHANGE_REASON iReason)
{
	if(iNewStatus != g_iStatus[iClient])
	{
		Call_StartForward(g_hForward_OnStatusChange);

		PRIME_STATUS iTemporaryStatus = iNewStatus;
		Call_PushCell(iClient);
		Call_PushCellRef(iTemporaryStatus);
		Call_PushCell(iReason);

		Action aAction = Plugin_Continue;
		Call_Finish(aAction);

		switch(aAction)
		{
			case Plugin_Continue:	g_iStatus[iClient] = iNewStatus;
			case Plugin_Changed:	g_iStatus[iClient] = iTemporaryStatus;
		}

		Call_StartForward(g_hForward_OnStatusChangePost);

		Call_PushCell(iClient);
		Call_PushCell(g_iStatus[iClient]);
		Call_PushCell(iReason);

		Call_Finish();
	}
	return g_iStatus[iClient];
}

public void OnClientDisconnect(int iClient)
{
	g_iStatus[iClient] = NO_AUTH;
	g_bLoaded[iClient] = false;
}

int GetClientFromAccountId(int iAccountID)
{
	static int i;
	for(i = 1; i <= MaxClients; ++i)		if(IsClientConnected(i) && GetSteamAccountID(i) == iAccountID)
	{
		return i;
	}
	return -1;
}

bool CheckClient(int iClient, const char[] sFunction, bool bCheckValidation = true)
{
	static int iClientError;
	static const char sError[][] = {	"invalid", 
										"not loaded", 
										"a bot"			};

	if((iClientError = Function_GetClientError(iClient, bCheckValidation)) != 3)	ThrowNativeError(SP_ERROR_NATIVE, 
																					"[%s] Client index %i is %s.", 
																					sFunction, iClient, 
																					sError[iClientError]);
	return true;
}

int Function_GetClientError(int iClient, bool bCheckValidation)
{
	if (iClient < 1 || iClient > MaxClients)						return 0;
	else if (bCheckValidation && g_iStatus[iClient] == NO_AUTH)		return 1;
	else if (IsFakeClient(iClient))									return 2;
	return 3;
}