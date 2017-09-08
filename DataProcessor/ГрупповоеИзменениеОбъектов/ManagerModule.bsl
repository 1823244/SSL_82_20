﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ВыполнитьИзменениеОбъектов(Параметры, АдресРезультата) Экспорт
	
	ОбрабатываемыеОбъекты = Параметры.ОбрабатываемыеОбъекты;
	ОстанавливатьИзменениеПриОшибке = Параметры.ОстанавливатьИзменениеПриОшибке;
	
	ИзменятьВТранзакции = Параметры.ИзменятьВТранзакции;
	ПрерыватьПриОшибке = Параметры.ПрерыватьПриОшибке;
	ИспользуютсяДопРеквизиты = Параметры.ИспользуютсяДопРеквизиты;
	ИспользуютсяДопСведения = Параметры.ИспользуютсяДопСведения;
	
	Операции = Параметры.Операции;
	ОбъектыДляИзменения = Параметры.ОбъектыДляИзменения;
	
	УправлениеСвойствамиМодуль = Параметры.УправлениеСвойствамиМодуль;
	
	РезультатИзменения = Новый Структура("ЕстьОшибки, СостояниеОбработки");
	РезультатИзменения.ЕстьОшибки			= Ложь;
	РезультатИзменения.СостояниеОбработки	= Новый Соответствие;
	
	Если ОстанавливатьИзменениеПриОшибке = Неопределено Тогда
		ОстанавливатьИзменениеПриОшибке = ПрерыватьПриОшибке;
	КонецЕсли;
	
	Если ОбрабатываемыеОбъекты = Неопределено Тогда
		ОбрабатываемыеОбъекты = Новый Массив;
		Для Каждого СтрокаИзменяемыйОбъект Из ОбъектыДляИзменения Цикл
			ОбрабатываемыеОбъекты.Добавить(СтрокаИзменяемыйОбъект.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	ПроверятьНаГруппу = ПроверятьНаГруппу(ОбрабатываемыеОбъекты[0]);
	
	Если ИзменятьВТранзакции Тогда
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	КонецЕсли;
	
	ОперацииИзменения = Операции.НайтиСтроки(Новый Структура("Изменять", Истина));
	
	Для Каждого Ссылка Из ОбрабатываемыеОбъекты Цикл
		
		ИзменяемыйОбъект = Ссылка.ПолучитьОбъект();
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(ИзменяемыйОбъект.Ссылка);
		Исключение
			Инфо = ИнформацияОбОшибке();
			КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(Инфо);
			ЗаполнитьРезультатИзменения(РезультатИзменения, Ссылка, "Ошибка_БлокировкиОбъекта", КраткоеПредставлениеОшибки);
			Если ИзменятьВТранзакции Тогда
				ОтменитьТранзакцию();
				ПоместитьВоВременноеХранилище(РезультатИзменения, АдресРезультата);
				Возврат;
			КонецЕсли;
			Если ОстанавливатьИзменениеПриОшибке Тогда
				ПоместитьВоВременноеХранилище(РезультатИзменения, АдресРезультата);
				Возврат;
			КонецЕсли;
			Продолжить;
		КонецПопытки;
		
		ИзменяемыеРеквизитыОбъекта = Новый Массив;
		ИзменяемыеДопРеквизитыОбъекта = Новый Соответствие;
		ИзменяемыеДопСведенияОбъекта = Новый Соответствие;
		
		МассивЗаписейДопСведений = Новый Массив;
		
		///////////////////////////////////////////////////////////////////////////////////////
		// Отбор операций изменения по каждому объекту
		//
		
		Для Каждого Операция Из ОперацииИзменения Цикл
			
			Если Операция.ВидОперации = 1 Тогда // изменение реквизита
				
				// для групп не устанавливаем реквизиты, которых у них нет
				Если ПроверятьНаГруппу И ИзменяемыйОбъект.ЭтоГруппа Тогда
					Если НЕ ОбщегоНазначения.ЭтоСтандартныйРеквизит(ИзменяемыйОбъект.Метаданные().СтандартныеРеквизиты, Операция.ИмяРеквизита) Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				
				ИзменяемыйОбъект[Операция.ИмяРеквизита] = Операция.Значение;
				ИзменяемыеРеквизитыОбъекта.Добавить(Операция.ИмяРеквизита);
				
			ИначеЕсли Операция.ВидОперации = 2 Тогда // изменение доп реквизита
				
				Если Не СвойствоНужноИзменять(ИзменяемыйОбъект.Ссылка, Операция.Свойство, Параметры) Тогда
					Продолжить;
				КонецЕсли;
				
				НайденнаяСтрока = ИзменяемыйОбъект.ДополнительныеРеквизиты.Найти(Операция.Свойство, "Свойство");
				
				Если НайденнаяСтрока = Неопределено Тогда
					НайденнаяСтрока = ИзменяемыйОбъект.ДополнительныеРеквизиты.Добавить();
					НайденнаяСтрока.Свойство = Операция.Свойство;
				КонецЕсли;
				
				НайденнаяСтрока.Значение = Операция.Значение;
				
				ИмяРеквизитаФормы = ПрефиксИмениДопРеквизита() + СтрЗаменить(Строка(Операция.Свойство.УникальныйИдентификатор()), "-", "_");
				ИзменяемыеДопРеквизитыОбъекта.Вставить(ИмяРеквизитаФормы, Операция.Значение);
				
			ИначеЕсли Операция.ВидОперации = 3 Тогда // изменение доп сведения
				
				Если Не СвойствоНужноИзменять(ИзменяемыйОбъект.Ссылка, Операция.Свойство, Параметры) Тогда
					Продолжить;
				КонецЕсли;
				
				МенеджерЗаписи = РегистрыСведений["ДополнительныеСведения"].СоздатьМенеджерЗаписи();
				
				МенеджерЗаписи.Объект = ИзменяемыйОбъект.Ссылка;
				МенеджерЗаписи.Свойство = Операция.Свойство;
				МенеджерЗаписи.Значение = Операция.Значение;
				
				МассивЗаписейДопСведений.Добавить(МенеджерЗаписи);
				
				ИмяРеквизитаФормы = ПрефиксИмениДопСведения() + СтрЗаменить(Строка(Операция.Свойство.УникальныйИдентификатор()), "-", "_");
				ИзменяемыеДопСведенияОбъекта.Вставить(ИмяРеквизитаФормы, Операция.Значение);
				
			КонецЕсли;
			
		КонецЦикла; 
		
		//
		// Отбор операций изменения по каждому объекту
		///////////////////////////////////////////////////////////////////////////////////////
		
		///////////////////////////////////////////////////////////////////////////////////////
		// Блок обработки проверки заполнения 
		//
		
		ПрерватьИзменение = Ложь;
		ПроверкаЗаполненияУспешно = Истина;
		
		Попытка
			Если ИзменяемыйОбъект.ПроверитьЗаполнение() Тогда
				
			Иначе
				ЗаполнитьРезультатИзменения(РезультатИзменения, Ссылка, "Ошибка_ОбработкиПроверкиЗаполнения",
						НСтр("ru = 'Ошибка проверки заполнения.'")+ПолучитьСтрокуСообщенийОбОшибках());
				Если ОстанавливатьИзменениеПриОшибке Или ИзменятьВТранзакции Тогда
					ПрерватьИзменение = Истина;
				КонецЕсли;
				ПроверкаЗаполненияУспешно = Ложь;
			КонецЕсли;
		Исключение
			Инфо = ИнформацияОбОшибке();
			КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(Инфо);
			ЗаполнитьРезультатИзменения(РезультатИзменения, Ссылка, "Ошибка_НеКлассифицированная", КраткоеПредставлениеОшибки);
			Если ОстанавливатьИзменениеПриОшибке Или ИзменятьВТранзакции Тогда
				ПрерватьИзменение = Истина;
			КонецЕсли;
			ПроверкаЗаполненияУспешно = Ложь;
		КонецПопытки;
		
		Если ПрерватьИзменение Тогда
			Если ИзменятьВТранзакции Тогда
				ОтменитьТранзакцию();
			КонецЕсли;
			ПоместитьВоВременноеХранилище(РезультатИзменения, АдресРезультата);
			Возврат;
		КонецЕсли;
		
		Если НЕ ПроверкаЗаполненияУспешно Тогда
			Продолжить;
		КонецЕсли;
		
		//
		// Блок обработки проверки заполнения
		///////////////////////////////////////////////////////////////////////////////////////
		
		///////////////////////////////////////////////////////////////////////////////////////
		// Блок записи дополнительных сведений
		//
		
		Если МассивЗаписейДопСведений.Количество() > 0 Тогда
			
			Если НЕ ИзменятьВТранзакции Тогда
				// Если транзакция при изменении объектов не используется, включаем ее
				// для изменения доп сведений в регистре
				НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
			КонецЕсли;
			
			Попытка
				Для Каждого МенеджерЗаписи Из МассивЗаписейДопСведений Цикл
					МенеджерЗаписи.Записать(Истина);
				КонецЦикла;
			Исключение
				Инфо = ИнформацияОбОшибке();
				
				КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(Инфо);
				ЗаполнитьРезультатИзменения(РезультатИзменения, Ссылка, "Ошибка_ЗаписиДопСведений", КраткоеПредставлениеОшибки);
				
				ОтменитьТранзакцию();
				
				Если ИзменятьВТранзакции ИЛИ ОстанавливатьИзменениеПриОшибке Тогда
					ПоместитьВоВременноеХранилище(РезультатИзменения, АдресРезультата);
					Возврат;
				КонецЕсли;
			КонецПопытки;
			
		КонецЕсли;
		
		//
		// Блок записи дополнительных сведений
		///////////////////////////////////////////////////////////////////////////////////////
		
		Отказ = Ложь;
		Попытка
			ИзменяемыйОбъект.Записать();
		Исключение
			Инфо = ИнформацияОбОшибке();
			Отказ = Истина;
			КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(Инфо);
			ЗаполнитьРезультатИзменения(РезультатИзменения, Ссылка, 
							"Ошибка_ЗаписиОбъекта",
							КраткоеПредставлениеОшибки + Символы.ПС + ПолучитьСтрокуСообщенийОбОшибках());
			Если ИзменятьВТранзакции И ТранзакцияАктивна() Тогда // отменяем транзакцию на любом уровне рекурсии
				ОтменитьТранзакцию();
			КонецЕсли;
			Если ПрерыватьПриОшибке Тогда
				ПоместитьВоВременноеХранилище(РезультатИзменения, АдресРезультата);
				Возврат;
			КонецЕсли;
		КонецПопытки;
		
		// Фиксируем транзакцию записи доп. свойств, если запись объектов происходит
		// не в транзакции
		Если НЕ ИзменятьВТранзакции И МассивЗаписейДопСведений.Количество() > 0 Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
		
		Если Не Отказ Тогда
			ЗаполнитьРезультатИзменения(РезультатИзменения, Ссылка, "",, 
						ИзменяемыйОбъект, ИзменяемыеРеквизитыОбъекта,
						ИзменяемыеДопРеквизитыОбъекта, ИзменяемыеДопСведенияОбъекта);
		КонецЕсли;
		
		РазблокироватьДанныеДляРедактирования(ИзменяемыйОбъект.Ссылка);
		
	КонецЦикла;
	
	Если ИзменятьВТранзакции И ТранзакцияАктивна() Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(РезультатИзменения, АдресРезультата);
	Возврат;

КонецПроцедуры

Функция СвойствоНужноИзменять(Ссылка, Свойство, Параметры)
	
	ОбъектыДляИзменения = Параметры.ОбъектыДляИзменения;
	УправлениеСвойствамиМодуль = Параметры.УправлениеСвойствамиМодуль;
	
	Если УправлениеСвойствамиМодуль = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтрокаИзменяемогоОбъекта = ОбъектыДляИзменения.Найти(Ссылка, "Ссылка");
	
	Если СтрокаИзменяемогоОбъекта = Неопределено Тогда
		Если НЕ УправлениеСвойствамиМодуль.ПроверитьСвойствоУОбъекта(Ссылка, Свойство) Тогда
			Возврат Ложь;
		КонецЕсли;
	Иначе
		СвойствоНайдено = Ложь;
		
		Если Свойство.ЭтоДополнительноеСведение Тогда
			КоллекцияСвойств = СтрокаИзменяемогоОбъекта.СоставДопСведений;
		Иначе
			КоллекцияСвойств = СтрокаИзменяемогоОбъекта.СоставДопРеквизитов;
		КонецЕсли;
		
		Если ПустаяСтрока(КоллекцияСвойств) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Для ИндексСтроки = 1 По СтрЧислоСтрок(КоллекцияСвойств) Цикл
			СтрокаУИд = СтрПолучитьСтроку(КоллекцияСвойств, ИндексСтроки);
			СвойствоОбъекта = ПланыВидовХарактеристик["ДополнительныеРеквизитыИСведения"].ПолучитьСсылку(Новый УникальныйИдентификатор(СокрЛП(СтрокаУИд)));
			Если Свойство = СвойствоОбъекта Тогда // свойство найдено у объекта
				СвойствоНайдено = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не СвойствоНайдено Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьСтрокуСообщенийОбОшибках()
	
	ПредставлениеОшибки = "";
	МассивСообщений = ПолучитьСообщенияПользователю(Истина);
	
	Для Каждого СообщениеПользователю Из МассивСообщений Цикл
		ПредставлениеОшибки = ПредставлениеОшибки + СообщениеПользователю.Текст + Символы.ПС;
	КонецЦикла;
	
	Возврат ПредставлениеОшибки;
	
КонецФункции

Процедура ЗаполнитьРезультатИзменения(Результат, Ссылка, КодОшибки, СообщениеОбОшибке = "",
		ИзменяемыйОбъект = Неопределено, ИзменяемыеРеквизитыОбъекта = Неопределено,
		ИзменяемыеДопРеквизитыОбъекта = Неопределено, ИзменяемыеДопСведенияОбъекта = Неопределено)
	
	СостояниеИзменения = Новый Структура("КодОшибки,СообщениеОбОшибке");
	
	Если ПустаяСтрока(КодОшибки) Тогда
		СостояниеИзменения.Вставить("ЗначенияИзмененныхРеквизитов", Новый Соответствие);
		Если ИзменяемыеРеквизитыОбъекта <> Неопределено Тогда
			Для Каждого ИмяРеквизита Из ИзменяемыеРеквизитыОбъекта Цикл
				СостояниеИзменения.ЗначенияИзмененныхРеквизитов.Вставить(ИмяРеквизита, ИзменяемыйОбъект[ИмяРеквизита]);
			КонецЦикла;
		КонецЕсли;
		СостояниеИзменения.Вставить("ЗначенияИзмененныхДопРеквизитов", ИзменяемыеДопРеквизитыОбъекта);
		СостояниеИзменения.Вставить("ЗначенияИзмененныхДопСведений", ИзменяемыеДопСведенияОбъекта);
	Иначе
		Результат.ЕстьОшибки = Истина;
	КонецЕсли;
	
	СостояниеИзменения.КодОшибки = КодОшибки;
	СостояниеИзменения.СообщениеОбОшибке = СообщениеОбОшибке;
	
	Результат.СостояниеОбработки.Вставить(Ссылка, СостояниеИзменения);
	
КонецПроцедуры

Функция ПрефиксИмениДопРеквизита()
	Возврат "ДопРеквизит_";
КонецФункции

Функция ПрефиксИмениДопСведения()
	Возврат "ДопСведение_";
КонецФункции

Функция ПроверятьНаГруппу(Ссылка)
	
	ВидОбъекта = ОбщегоНазначения.ВидОбъектаПоСсылке(Ссылка);
	МетаданныеОбъекта = Ссылка.Метаданные();
	
	Если ВидОбъекта = "Справочник"
	   И МетаданныеОбъекта.Иерархический
	   И МетаданныеОбъекта.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции
