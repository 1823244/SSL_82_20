﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СписокПолейСопоставления = Параметры.СписокПолейСопоставления;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстПоясняющейНадписи();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СписокПолейСопоставленияПриИзменении(Элемент)
	
	ОбновитьТекстПоясняющейНадписи();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьСопоставление(Команда)
	
	ЭтаФорма.Закрыть(СписокПолейСопоставления.Скопировать());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЭтаФорма.Закрыть(Неопределено);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьТекстПоясняющейНадписи()
	
	МассивОтмеченныхЭлементовСписка = ОбщегоНазначенияКлиентСервер.ПолучитьМассивОтмеченныхЭлементовСписка(СписокПолейСопоставления);
	
	Если МассивОтмеченныхЭлементовСписка.Количество() = 0 Тогда
		
		ПоясняющаяНадпись = НСтр("ru = 'Сопоставление будет выполнено только по уникальным идентификаторам объектов.'");
		
	Иначе
		
		ПоясняющаяНадпись = НСтр("ru = 'Сопоставление будет выполнено по уникальным идентификаторам объектов и по выбранным полям.'");
		
	КонецЕсли;
	
КонецПроцедуры

