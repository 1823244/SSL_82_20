﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Клиентские процедуры и функции общего назначения.
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает Истина, если этот веб клиент не поддерживает расширение работы с файлами.
Функция ЭтоВебКлиентБезПоддержкиРасширенияРаботыСФайлами() Экспорт
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	
	Если Найти(СистемнаяИнфо.ИнформацияПрограммыПросмотра, "Safari") <> 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Найти(СистемнаяИнфо.ИнформацияПрограммыПросмотра, "Chrome") <> 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если это веб клиент в Mac OS.
Функция ЭтоВебКлиентПодMacOS() Экспорт
	
#Если Не ВебКлиент Тогда
	Возврат Ложь;  // только в веб клиенте этот код работает		
#КонецЕсли
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если Найти(СистемнаяИнфо.ИнформацияПрограммыПросмотра, "Macintosh") <> 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает тип платформы клиента.
Функция ТипПлатформыКлиента() Экспорт
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Возврат СистемнаяИнфо.ТипПлатформы;
КонецФункции	
