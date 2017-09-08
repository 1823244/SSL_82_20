﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСообщениямиПовтИсп: механизм обмена сообщениями.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает ссылку на объект WSПрокси для заданного узла обмена.
//
// Параметры:
// КонечнаяТочка - ПланОбменаСсылка.
//
Функция WSПроксиКонечнойТочки(КонечнаяТочка) Экспорт
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбмена.ПолучитьНастройкиТранспортаWS(КонечнаяТочка);
	
	СтрокаСообщенияОбОшибке = "";
	
	Результат = ОбменСообщениямиВнутренний.ПолучитьWSПрокси(СтруктураНастроек, СтрокаСообщенияОбОшибке);
	
	Если Результат = Неопределено Тогда
		ВызватьИсключение СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции
