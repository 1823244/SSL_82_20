﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Вызывается при необходимости получить номер документа для вывода на печать.
//
// Параметры:
//   НомерОбъекта - Строка - код или номер объекта
//   СтандартнаяОбработка - Булево - если вернуть Ложь, то будет учтено
//                                   значение выходного параметра НомерОбъекта 
// 
Процедура ПолучитьНомерНаПечать(НомерОбъекта, СтандартнаяОбработка) Экспорт
	
	// СтандартныеПодсистемы.ПрефиксацияОбъектов
	НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(НомерОбъекта);
	СтандартнаяОбработка = Ложь;
	// Конец СтандартныеПодсистемы.ПрефиксацияОбъектов
	
КонецПроцедуры
