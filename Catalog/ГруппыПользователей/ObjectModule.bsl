﻿
Перем СтарыйРодитель; // Значение родителя группы до изменения для использования
//                       в обработчике события ПриЗаписи.

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Блокирует недопустимые действия с предопределенной группой "Все пользователи".
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Ссылка = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		Если НЕ Родитель.Пустая() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Предопределенная группа ""Все пользователи"" может быть только в корне.'"),
				, , , Отказ);
			Возврат;
		КонецЕсли;
		Если Состав.Количество() > 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Добавление пользователей в группу ""Все пользователи"" не поддерживается.'"),
				, , , Отказ);
			Возврат;
		КонецЕсли;
	Иначе
		Если Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Предопределенная группа ""Все пользователи"" не может быть родителем.'"),
				, , , Отказ);
			Возврат;
		КонецЕсли;
		
		СтарыйРодитель = ?(Ссылка.Пустая(), Неопределено, ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Родитель"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Пользователи.ОбновитьСоставыГруппПользователей(Ссылка);
		
	Если ЗначениеЗаполнено(СтарыйРодитель) И СтарыйРодитель <> Родитель Тогда
		Пользователи.ОбновитьСоставыГруппПользователей(СтарыйРодитель);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверенныеРеквизитыОбъекта = Новый Массив;
	Ошибки = Неопределено;
	
	// Проверка использования родителя.
	Если Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Объект.Родитель",
			НСтр("ru = 'Предопределенная группа ""Все пользователи"" не может быть родителем.'"));
	КонецЕсли;
	
	// Проверка незаполненных и повторяющихся пользователей.
	ПроверенныеРеквизитыОбъекта.Добавить("Состав.Пользователь");
	
	Для каждого ТекущаяСтрока Из Состав Цикл;
		НомерСтроки = Состав.Индекс(ТекущаяСтрока);
		
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Пользователь) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].Пользователь",
				НСтр("ru = 'Пользователь не выбран.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Пользователь в строке %1 не выбран.'"));
			Продолжить;
		КонецЕсли;
		
		// Проверка наличия повторяющихся значений.
		НайденныеЗначения = Состав.НайтиСтроки(Новый Структура("Пользователь", ТекущаяСтрока.Пользователь));
		Если НайденныеЗначения.Количество() > 1 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].Пользователь",
				НСтр("ru = 'Пользователь повторяется.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Пользователь в строке %1 повторяется.'"));
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверенныеРеквизитыОбъекта);
	
КонецПроцедуры
