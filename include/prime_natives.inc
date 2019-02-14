#if defined _prime_natives_included
 #endinput
#endif
#define _prime_natives_included


enum PRIME_STATUS			// Статусы клиента
{
	PRIME,					// Клиент имеет Prime статус.
	NO_PRIME,				// Клиент не имеет Prime статус.
	NO_AUTH,				// Не удалось получить Prime статус игрока.
	VERIFICATION,			// Игрок проверяется каким-либо плагином.
	WHITE_LIST				// Игрок находится в белом списке.
}

enum STATUS_CHANGE_REASON	// Причины смены статуса
{
	PLAYER_LOAD,			// Клиент загрузился и был проверен.
	WHITE_LIST_ADD,			// Клиент был добавлен в белый список.
	WHITE_LIST_REMOVE,		// Клиент был удален из белого списка.
	VERIFICATION_END,		// Проверка игрока окончена
	IGNORE					// Игнорирование
}

/**
 *	Вызывается когда клиент был проверен на Prime статус.
 *
 *	@param iClient			Индекс клиента.
 *	@param &iStatus			Статус клиента. Можно изменить.
 *	@noreturn
*/
forward void PN_OnPlayerAuthorized(int iClient, PRIME_STATUS &iStatus);

/**
 *	Вызывается перед установкой статуса клиенту.
 *
 *	@param iClient			Индекс клиента.
 *	@param &iStatus			Новый статус клиента. Можно изменить.
 *	@param iReason			Причина смены статуса.
 * 	@return					Plugin_Continue - разрешить смену статуса,
 *							Plugin_Changed - разрешить смену статуса на указанный в iStatus.
 * 							Plugin_Handled/Plugin_Stop - запретить.
*/
forward Action PN_OnPlayerStatusChange(int iClient, PRIME_STATUS &iNewStatus, STATUS_CHANGE_REASON iReason);

/**
 *	Вызывается после установки статуса клиенту.
 *
 *	@param iClient			Индекс клиента.
 *	@param &iStatus			Новый статус клиента.
 *	@param iReason			Причина смены статуса.
 * 	@noreturn
*/
forward void PN_OnPlayerStatusChangePost(int iClient, PRIME_STATUS iNewStatus, STATUS_CHANGE_REASON iReason);

/**
 *	Возвращает Prime статус игрока.
 *	@param iClient			Индекс клиента.
 *	@return                 Статус игрока.
*/
native PRIME_STATUS PN_GetPlayerStatus(int iClient)

/**
 *	Устанавливает Prime статус игрока.
 *	@param iClient			Индекс клиента.
 *	@param iStatus			Устанавливаемый статус.
 *	@param iReason			Причина смены статуса.
 *	@return                	true, если удачно, иначе false.
*/
native bool PN_SetPlayerStatus(int iClient, PRIME_STATUS iStatus, STATUS_CHANGE_REASON iReason = IGNORE)

/**
 *	Запускает проверку игрока.
 *	@param iClient			Индекс клиента.
 *	@param iReason			Причина смены статуса.
 *	@return                	Статус игрока.
*/
native PRIME_STATUS PN_ForcePlayerCheck(int iClient, STATUS_CHANGE_REASON iReason = IGNORE)


public SharedPlugin __pl_prime_natives= 
{
	name = "prime_natives",
	file = "Prime_Natives.smx",
#if defined REQUIRE_PLUGIN
	required = 1
#else
	required = 0
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_prime_natives_SetNTVOptional()
{
	MarkNativeAsOptional("PN_GetPlayerStatus");
	MarkNativeAsOptional("PN_SetPlayerStatus");
	MarkNativeAsOptional("PN_ForcePlayerCheck");
}
#endif
