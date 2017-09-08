﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получить доступные наборы свойств для объекта.
//
// Параметры:
//  Объект       - Ссылка или Объект владельца свойств.
//
// Возвращаемые значения:
//  Список значений (в т.ч. пустой), если объект может содержать несколько наборов свойств.
//  Неопределено, если объект не может содержать несколько наборов свойств.
//
Функция ПолучитьДоступныеНаборыСвойствПоОбъекту(Объект) Экспорт
	
	
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает имя реквизита, содержащего вид владельцев свойств (если есть).
// Если возвращается имя реквизита, то вид владельцев свойств
// (например, вид номенклатуры), должен содержать реквизит НаборСвойств
// типа СправочникСсылка.НаборыДополнительныхРеквизитовИСведений.
//
// Параметры:
//  Ссылка       - Ссылка владельца свойств.
//
// Возвращаемые значения:
//  Строка - имя реквизита или пустая строка.
//
Функция ПолучитьИмяРеквизитаВидаОбъекта(Ссылка) Экспорт
	
	
	
	Возврат "";
	
КонецФункции



