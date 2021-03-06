﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполнение списка валют из ОКВ
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьТаблицуВалют();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокВалют

&НаКлиенте
Процедура СписокВалютВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// Оповещает о выборе вызывающую форму. Форма закрывается.
	ОбработатьВыборВСпискеВалют(Элемент.ТекущиеДанные);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	ОбработатьВыборВСпискеВалют(Элементы.СписокВалют.ТекущиеДанные);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьТаблицуВалют()
	
	// Заполняет список валют из макета ОКВ
	
	КлассификаторXML = Справочники.Валюты.ПолучитьМакет("ОбщероссийскийКлассификаторВалют").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого ЗаписьОКВ Из КлассификаторТаблица Цикл
		НоваяСтрока = Валюты.Добавить();
		НоваяСтрока.КодВалютыЦифровой         = ЗаписьОКВ.Code;
		НоваяСтрока.КодВалютыБуквенный        = ЗаписьОКВ.CodeSymbol;
		НоваяСтрока.Наименование              = ЗаписьОКВ.Name;
		НоваяСтрока.СтраныИТерритории         = ЗаписьОКВ.Description;
		НоваяСтрока.Загружается               = ЗаписьОКВ.RBCLoading;
		НоваяСтрока.ПараметрыПрописиНаРусском = ЗаписьОКВ.NumerationItemOptions;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВСпискеВалют(ТекущиеДанные)
	
	// Оповещает о выборе вызывающую форму. Форма закрывается.
	
	ПараметрыВыбор = Новый Структура("КодВалюты, НаименованиеКраткое, НаименованиеПолное, Загружается, ПараметрыПрописиНаРусском");
	ПараметрыВыбор.КодВалюты                 = ТекущиеДанные.КодВалютыЦифровой;
	ПараметрыВыбор.НаименованиеКраткое       = ТекущиеДанные.КодВалютыБуквенный;
	ПараметрыВыбор.НаименованиеПолное        = ТекущиеДанные.Наименование;
	ПараметрыВыбор.Загружается               = ТекущиеДанные.Загружается;
	ПараметрыВыбор.ПараметрыПрописиНаРусском = ТекущиеДанные.ПараметрыПрописиНаРусском;
	
	ОповеститьОВыборе(ПараметрыВыбор);
	
КонецПроцедуры

