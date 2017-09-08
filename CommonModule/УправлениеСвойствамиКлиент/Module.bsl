﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выбирает набор свойств (если нужно) и открывает форму редактирования свойств.
Процедура РедактироватьСоставСвойств(Форма, Ссылка) Экспорт
	
	Наборы = Форма.Свойства_ОсновнойНабор;
	
	Если ТипЗнч(Наборы) = Тип("СправочникСсылка.НаборыДополнительныхРеквизитовИСведений") Тогда
		// Объект с одним набором свойств.
		Если ЗначениеЗаполнено(Наборы) Тогда
			ПараметрыФормыНабораСвойств = Новый Структура("Ключ", Форма.Свойства_ОсновнойНабор);
			ОткрытьФорму("Справочник.НаборыДополнительныхРеквизитовИСведений.Форма.ФормаЭлемента", ПараметрыФормыНабораСвойств);
		Иначе
			Предупреждение(НСтр("ru = 'Нельзя получить набор свойств объекта. Возможно не заполнены необходимые реквизиты.'"));
		КонецЕсли;
		
	Иначе
		// Объект с несколькими наборами свойств.
		Если Наборы.Количество() = 1 Тогда
			Элемент = Наборы.Получить(0);
		Иначе
			// Выбор редактируемого набора.
			Элемент = Наборы.ВыбратьЭлемент();
			Если Элемент = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		ПараметрыФормыНабораСвойств = Новый Структура("Ключ", Элемент.Значение);
		ОткрытьФорму("Справочник.НаборыДополнительныхРеквизитовИСведений.Форма.ФормаЭлемента", ПараметрыФормыНабораСвойств);
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет, что указанное событие - это событие об изменении набора свойств.
// 
// Возвращаемое значение:
//  Булево - если Истина, тогда это оповещение об изменении набора свойств и
//           его нужно обработать в форме.
//
Функция ОбрабатыватьОповещения(Форма, ИмяСобытия, Параметр) Экспорт
	
	Если (ИмяСобытия <> "Запись_НаборыДополнительныхРеквизитовИСведений") ИЛИ Не Форма.Свойства_ИспользоватьСвойства Тогда
		Возврат Ложь;
		
	ИначеЕсли Форма.Свойства_ОсновнойНабор = Параметр Тогда
		Возврат Истина;
		
	ИначеЕсли (ТипЗнч(Форма.Свойства_ОсновнойНабор) = Тип("СписокЗначений"))
		И (Форма.Свойства_ОсновнойНабор.НайтиПоЗначению(Параметр) <> Неопределено) Тогда
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции
