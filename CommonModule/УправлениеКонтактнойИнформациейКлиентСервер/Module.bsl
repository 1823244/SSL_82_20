﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция формирует представление с видом для формы ввода адреса.
//
// Параметры:
//	СтруктураАдреса - Структура - стурктура адреса.
//	Представление - Строка - представление адреса.
//	НаименованиеВида - Строка - наименование вида.
//
// Возвращаемое значение:
//	Строка - представление адреса с видом.
//
Функция СформироватьПредставлениеАдреса(СтруктураАдреса, Представление, НаименованиеВида = Неопределено) Экспорт 
	
	Представление = "";
	
	Страна = ЗначениеПоКлючуСтуктуры("Страна", СтруктураАдреса);
	
	Если Страна <> Неопределено Тогда
		ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("НаименованиеСтраны", СтруктураАдреса)), ", ", Представление);
	КонецЕсли;
	
	ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("Индекс", СтруктураАдреса)),           	 ", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("Регион", СтруктураАдреса)),             ", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("Район", СтруктураАдреса)),              ", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("Город", СтруктураАдреса)),              ", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("НаселенныйПункт", СтруктураАдреса)),    ", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("Улица", СтруктураАдреса)),              ", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("Дом", СтруктураАдреса)),                ", " + ЗначениеПоКлючуСтуктуры("ТипДома", СтруктураАдреса)    + " № ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("Корпус", СтруктураАдреса)),             ", " + ЗначениеПоКлючуСтуктуры("ТипКорпуса ", СтруктураАдреса)+ " ",	Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтуктуры("Квартира", СтруктураАдреса)),           ", " + ЗначениеПоКлючуСтуктуры("ТипКвартиры", СтруктураАдреса) + " ",	Представление);
	
	Если СтрДлина(Представление) > 2 Тогда
		Представление = Сред(Представление, 3);
	КонецЕсли;
	
	НаименованиеВида	= ЗначениеПоКлючуСтуктуры("НаименованиеВида", СтруктураАдреса);
	ПредставлениеСВидом = НаименованиеВида + ": " + Представление;
	
	Возврат ПредставлениеСВидом;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Дополняет представление адреса строкой.
//
// Параметры:
//	Дополнение - Строка - дополнение адреса.
//	СтрокаКонкатенации - Строка - строка конкатенации.
//	Представление - Строка - представление адреса.
//
Процедура ДополнитьПредставлениеАдреса(Дополнение, СтрокаКонкатенации, Представление)
	
	Если Дополнение <> "" Тогда
		Представление = Представление + СтрокаКонкатенации + Дополнение;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает строку значения по свойству структуры.
// 
// Параметры:
//	Ключ - Строка - ключ структуры.
//  Структура - Структура - передаваемая структура.
//
// Возвращаемое значение - ПустаяСтрока или ПроизвольныйТип - значение.
//
Функция ЗначениеПоКлючуСтуктуры(Ключ, Структура)
	
	Значение	= Неопределено;
	
	Если Структура.Свойство(Ключ, Значение) Тогда 
		Возврат Строка(Значение);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции	