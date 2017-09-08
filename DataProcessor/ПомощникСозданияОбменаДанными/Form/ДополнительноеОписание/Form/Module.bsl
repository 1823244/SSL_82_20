﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Макет = Обработки.ПомощникСозданияОбменаДанными.ПолучитьМакет(Параметры.ИмяМакета);
	
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Заголовок = Параметры.Заголовок;
	
КонецПроцедуры
