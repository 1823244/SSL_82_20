﻿//////////////////////////////////////////////////////
//// Запросы к Документообороту

//Получает объект из Документооборота
//Параметры:
//		Тип - имя типа XDTO
//		Ид - уникальный идентификатор объекта в Документообороте
//Возвращает:
//		XDTO Объект типа DMRetrieveResponse
Функция ПолучитьОбъект(Тип, Ид, Колонки = Неопределено) Экспорт
	
	Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();	
	Запрос = СоздатьОбъект(Прокси, "DMRetrieveRequest");
	
	objectId = СоздатьObjectID(Прокси, Ид, Тип);
	Запрос.objectIds.Добавить(objectId);
	
	Если Колонки <> Неопределено Тогда
		Для Каждого Колонка Из Колонки Цикл
			Запрос.columnSet.Добавить(Колонка);
		КонецЦикла;
	КонецЕсли;
	
	Ответ = Прокси.execute(Запрос);
	ПроверитьВозвратВебСервиса(Прокси, Ответ);

	Возврат Ответ;
	
КонецФункции

//Записывает изменения объекта в Документообороте
//Параметры:
//		Прокси - объект для подключения к web-сервисам Документооборота
//		Объект - XDTO объект с сохраняемыми данными
//Возвращает:
//		XDTO Объект типа DMUpdateResponse
Функция ЗаписатьОбъект(Прокси, Объект) Экспорт
	
	Запрос = СоздатьОбъект(Прокси, "DMUpdateRequest");
	Запрос.objects.Добавить(Объект);
	
	Ответ = Прокси.execute(Запрос);
	ПроверитьВозвратВебСервиса(Прокси, Ответ);

	Возврат Ответ;
	
КонецФункции

//Записывает изменения объектов в Документообороте
//Параметры:
//		Прокси - объект для подключения к web-сервисам Документооборота
//		Объект - XDTO объект с сохраняемыми данными
//Возвращает:
//		XDTO Объект типа DMUpdateResponse
Функция ЗаписатьОбъекты(Прокси, Объекты) Экспорт
	
	Запрос = СоздатьОбъект(Прокси, "DMUpdateRequest");
	
	Для Каждого Объект Из Объекты Цикл
		Запрос.objects.Добавить(Объект);
	КонецЦикла;	
	
	Ответ = Прокси.execute(Запрос);
	ПроверитьВозвратВебСервиса(Прокси, Ответ);

	Возврат Ответ;
	
КонецФункции

//Создает объект в Документооборот
//Параметры:
//		Прокси - объект для подключения к web-сервисам Документооборота
//		Объект - XDTO объект с сохраняемыми данными
//		ObjectIDВнешнегоОбъекта - уникальный идентификатор объекта в конфигурации-потребителе
//Возвращает:
//		XDTO Объект типа DMCreateResponse
Функция СоздатьНовыйОбъект(Прокси, Объект) Экспорт
	
	Запрос = СоздатьОбъект(Прокси, "DMCreateRequest");
	Запрос.object = Объект;
		
	Ответ = Прокси.execute(Запрос);
	ПроверитьВозвратВебСервиса(Прокси, Ответ);

	Возврат Ответ;
	
КонецФункции

//Получает заполненный по умолчанию объект из Документооборота
//Параметры:
//		Тип - имя типа XDTO объекта
//		ПредметБизнесПроцесса - Структура. Используется для получения бизнес-процессов.
//			id - уникальный идентификатор объекта в Документооборот
//			type - имя типа XDTO 
//Возвращает:
//		XDTO Объект типа DMGetNewObjectResponse
Функция ПолучитьНовыйОбъект(Тип, ПредметБизнесПроцесса = Неопределено) Экспорт
	
	Если ПредметБизнесПроцесса <> Неопределено Тогда
		Возврат ПолучитьНовыйБизнесПроцесс(Тип, ПредметБизнесПроцесса);
	Иначе
		Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();
		
		Запрос = СоздатьОбъект(Прокси, "DMGetNewObjectRequest");
		Запрос.type = Тип;
			
		Ответ = Прокси.execute(Запрос);
		ПроверитьВозвратВебСервиса(Прокси, Ответ);

		Если ПроверитьТип(Прокси, Ответ, "DMGetNewObjectResponse") Тогда
			Возврат Ответ.object;
		КонецЕсли;
		
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

//Выполняет сохранение и запуск бизнес-процесса
//Параметры:
//		Прокси - объект для подключения к web-сервисам Документооборота
//		Объект - XDTO объект, хранящий данные бизнес-процесса
//Возвращает:
//		XDTO Объект типа DMLaunchBusinessProcessResponse
Функция ЗапуститьБизнесПроцесс(Прокси, Объект) Экспорт
	
	Запрос = СоздатьОбъект(Прокси, "DMLaunchBusinessProcessRequest");
	Запрос.businessProcess = Объект;
		
	Ответ = Прокси.execute(Запрос);
	ПроверитьВозвратВебСервиса(Прокси, Ответ);

	Возврат Ответ;	
	
КонецФункции

//////////////////////////////////////////////////////
//// Работа с бизнес-процессами

//Устанавливает контролера бизнес-процесса на форму
//Параметры:
//	ОбъектXDTO - объект, содержащий данные бизнес-процесса, например, DMBusinessProcessOrder
//	Форма - форма, на которую необходимо поместить значение контролера
Процедура УстановитьКонтролераНаКарточке(ОбъектXDTO, Форма) Экспорт
	
	Если ОбъектXDTO.controller.Установлено("user") Тогда
		Форма.Контролер = ОбъектXDTO.controller.user.name;
		Форма.КонтролерID = ОбъектXDTO.controller.user.objectId.id;
		Форма.КонтролерТип = ОбъектXDTO.controller.user.objectId.type;
	ИначеЕсли ОбъектXDTO.controller.Установлено("role") Тогда
		Форма.Контролер = ОбъектXDTO.Controller.role.name;
		Форма.КонтролерID = ОбъектXDTO.Controller.role.objectId.id;
		Форма.КонтролерТип = ОбъектXDTO.Controller.role.objectId.type;
		
		Если ОбъектXDTO.controller.Установлено("mainAddressingObject") Тогда
			Форма.ОсновнойОбъектАдресацииКонтролера = ОбъектXDTO.controller.mainAddressingObject.name;
			Форма.ОсновнойОбъектАдресацииКонтролераID = ОбъектXDTO.controller.mainAddressingObject.objectId.id;
			Форма.ОсновнойОбъектАдресацииКонтролераТип = ОбъектXDTO.controller.mainAddressingObject.objectId.type;
		КонецЕсли;

		Если ОбъектXDTO.controller.Установлено("secondaryAddressingObject") Тогда 
			Форма.ДополнительныйОбъектАдресацииКонтролера = ОбъектXDTO.controller.secondaryAddressingObject.name;
			Форма.ДополнительныйОбъектАдресацииКонтролераID = ОбъектXDTO.controller.secondaryAddressingObject.objectId.id;
			Форма.ДополнительныйОбъектАдресацииКонтролераТип = ОбъектXDTO.controller.secondaryAddressingObject.objectId.type;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//Устанавливает проверяющего бизнес-процесса на форму
//Параметры:
//	ОбъектXDTO - объект, содержащий данные бизнес-процесса, например, DMBusinessProcessOrder
//	Форма - форма, на которую необходимо поместить значение контролера
Процедура УстановитьПроверяющегоНаКарточке(ОбъектXDTO, Форма) Экспорт
	
	Если ОбъектXDTO.verifier.Установлено("user") Тогда
		Форма.Проверяющий = ОбъектXDTO.verifier.user.name;
		Форма.ПроверяющийID = ОбъектXDTO.verifier.user.objectId.id;
		Форма.ПроверяющийТип = ОбъектXDTO.verifier.user.objectId.type;
	ИначеЕсли ОбъектXDTO.verifier.Установлено("role") Тогда
		Форма.Проверяющий = ОбъектXDTO.verifier.role.name;
		Форма.ПроверяющийID = ОбъектXDTO.verifier.role.objectId.id;
		Форма.ПроверяющийТип = ОбъектXDTO.verifier.role.objectId.type;
		
		Если ОбъектXDTO.verifier.Установлено("mainAddressingObject") Тогда
			Форма.ОсновнойОбъектАдресацииПроверяющего = ОбъектXDTO.verifier.mainAddressingObject.name;
			Форма.ОсновнойОбъектАдресацииПроверяющегоID = ОбъектXDTO.verifier.mainAddressingObject.objectId.id;
			Форма.ОсновнойОбъектАдресацииПроверяющегоТип = ОбъектXDTO.verifier.mainAddressingObject.objectId.type;
		КонецЕсли;

		Если ОбъектXDTO.verifier.Установлено("secondaryAddressingObject") Тогда 
			Форма.ДополнительныйОбъектАдресацииПроверяющего = ОбъектXDTO.verifier.secondaryAddressingObject.name;
			Форма.ДополнительныйОбъектАдресацииПроверяющегоID = ОбъектXDTO.verifier.secondaryAddressingObject.objectId.id;
			Форма.ДополнительныйОбъектАдресацииПроверяющегоТип = ОбъектXDTO.verifier.secondaryAddressingObject.objectId.type;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//Устанавливает исполнителя бизнес-процесса на форму.
//Используется, когда у бизнес-процесса предусмотрен только один исполнитель.
//Параметры:
//	ОбъектXDTO - объект, содержащий данные бизнес-процесса, например, DMBusinessProcessOrder
//	Форма - форма, на которую необходимо поместить значение контролера
Процедура УстановитьЕдинственногоИсполнителяНаКарточке(ОбъектXDTO, Форма) Экспорт
	
	Исполнитель = ОбъектXDTO.performer;
	Если Исполнитель.Установлено("user") Тогда
		Форма.Исполнитель = Исполнитель.user.name;
		Форма.ИсполнительID = Исполнитель.user.objectId.id;
		Форма.ИсполнительТип = Исполнитель.user.objectId.type;
	ИначеЕсли Исполнитель.Установлено("role") Тогда
		Форма.Исполнитель = Исполнитель.role.name;
		Форма.ИсполнительID = Исполнитель.role.objectId.id;
		Форма.ИсполнительТип = Исполнитель.role.objectId.type;
		
		Если Исполнитель.Установлено("mainAddressingObject") Тогда
			Форма.ОсновнойОбъектАдресации = Исполнитель.mainAddressingObject.name;
			Форма.ОсновнойОбъектАдресацииID = Исполнитель.mainAddressingObject.objectId.id;
			Форма.ОсновнойОбъектАдресацииТип = Исполнитель.mainAddressingObject.objectId.type;
		КонецЕсли;
		
		Если Исполнитель.Установлено("secondaryAddressingObject") Тогда 
			Форма.ДополнительныйОбъектАдресации = Исполнитель.secondaryAddressingObject.name;
			Форма.ДополнительныйОбъектАдресацииID = Исполнитель.secondaryAddressingObject.objectId.id;
			Форма.ДополнительныйОбъектАдресацииТип = Исполнитель.secondaryAddressingObject.objectId.type;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//Устанавливает исполнителя бизнес-процесса на форму.
//Используется, когда у бизнес-процесса предусмотрено несколько исполнителей.
//Параметры:
//	ОбъектXDTO - объект, содержащий данные бизнес-процесса, например, DMBusinessProcessOrder
//	Форма - форма, на которую необходимо поместить значение контролера
Процедура УстановитьИсполнителяВСпискеИсполнителейНаКарточке(ИсполнительXDTO, СтрокаСпискаИсполнителей) Экспорт
	
	Если ИсполнительXDTO.Установлено("user") Тогда
		СтрокаСпискаИсполнителей.Исполнитель = ИсполнительXDTO.user.name;
		СтрокаСпискаИсполнителей.ИсполнительID = ИсполнительXDTO.user.objectId.id;
		СтрокаСпискаИсполнителей.ИсполнительТип = ИсполнительXDTO.user.objectId.type;
	ИначеЕсли ИсполнительXDTO.Установлено("role") Тогда
		СтрокаСпискаИсполнителей.Исполнитель = ИсполнительXDTO.role.name;
		СтрокаСпискаИсполнителей.ИсполнительID = ИсполнительXDTO.role.objectId.id;
		СтрокаСпискаИсполнителей.ИсполнительТип = ИсполнительXDTO.role.objectId.type;
		Если ИсполнительXDTO.Установлено("mainAddressingObject") Тогда
			СтрокаСпискаИсполнителей.ОсновнойОбъектАдресации = ИсполнительXDTO.mainAddressingObject.name;
			СтрокаСпискаИсполнителей.ОсновнойОбъектАдресацииID = ИсполнительXDTO.mainAddressingObject.objectId.id;
			СтрокаСпискаИсполнителей.ОсновнойОбъектАдресацииТип = ИсполнительXDTO.mainAddressingObject.objectId.type;
		КонецЕсли;
		Если ИсполнительXDTO.Установлено("secondaryAddressingObject") Тогда 
			СтрокаСпискаИсполнителей.ДополнительныйОбъектАдресации = ИсполнительXDTO.secondaryAddressingObject.name;
			СтрокаСпискаИсполнителей.ДополнительныйОбъектАдресацииID = ИсполнительXDTO.secondaryAddressingObject.objectId.id;
			СтрокаСпискаИсполнителей.ДополнительныйОбъектАдресацииТип = ИсполнительXDTO.secondaryAddressingObject.objectId.type;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры

//Устанавливает стандартные реквизиты бизнес-процесса на форме
//Параметры:
//	ОбъектXDTO - объект, содержащий данные бизнес-процесса, например, DMBusinessProcessOrder
//	Форма - форма, на которую необходимо поместить значение реквизитов
Процедура УстановитьСтандартнуюШапкуБизнесПроцесса(ОбъектXDTO, Форма) Экспорт
	
	Если ОбъектXDTO.target = Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'Бизнес-процесс выбранного типа неприменим к данному документу.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	Форма.Стартован = ОбъектXDTO.started;
	Форма.Завершен = ОбъектXDTO.completed;
	Форма.ДатаНачала = ОбъектXDTO.beginDate;
	Форма.ДатаЗавершения = ОбъектXDTO.endDate;
	Форма.Наименование = ОбъектXDTO.name;
	Если Форма.Элементы.Найти("СрокДата") <> Неопределено Тогда
		Форма.Срок = ОбъектXDTO.dueDate;
	КонецЕсли;
	Если Форма.Элементы.Найти("Описание") <> Неопределено Тогда
		Форма.Описание = ОбъектXDTO.description;
	КонецЕсли;
	Форма.Тип = ОбъектXDTO.objectId.type;
	
	ЗаполнитьОбъектныйРеквизитФормы(Форма, "Автор", 		ОбъектXDTO, "author"); 
	ЗаполнитьОбъектныйРеквизитФормы(Форма, "Важность", 		ОбъектXDTO, "importance");
	ЗаполнитьОбъектныйРеквизитФормы(Форма, "Предмет", 		ОбъектXDTO, "target");
	ЗаполнитьОбъектныйРеквизитФормы(Форма, "ГлавнаяЗадача", ОбъектXDTO, "parentTask");
	
	Если ОбъектXDTO.started Или ОбъектXDTO.completed Тогда
		Форма.ТолькоПросмотр = Истина;
		Форма.Элементы.ФормаСтартоватьИЗакрыть.Доступность = Ложь;
		Форма.Элементы.ФормаЗаписать.Доступность = Ложь;
		Форма.Элементы.ФормаЗаполнитьПоШаблону.Доступность = Ложь;
	КонецЕсли;
	
	//изменение формы в зависимости от функциональных опций
	Если Форма.Элементы.Найти("ГлавнаяЗадачаПредставление") <> Неопределено Тогда
		Форма.Элементы.ГлавнаяЗадачаПредставление.Видимость = ОбъектXDTO.parentTaskEnabled;
	КонецЕсли;
	Если Форма.Элементы.Найти("СрокВремя") <> Неопределено Тогда
		Форма.Элементы.СрокВремя.Видимость = ОбъектXDTO.dueTimeEnabled;
	ИначеЕсли Форма.Элементы.Найти("СрокИсполненияЧасов") <> Неопределено Тогда
		Форма.Элементы.СрокИсполненияЧасов.Видимость = ОбъектXDTO.dueTimeEnabled;
		Форма.Элементы.Часов.Видимость = ОбъектXDTO.dueTimeEnabled;
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗаполнитьОбъектныйРеквизитФормы(Форма, ИмяРеквизита, ОбъектXDTO, ИмяСвойстваОбъекта)
	
	Если ОбъектXDTO.Установлено(ИмяСвойстваОбъекта)	И ЗначениеЗаполнено(ОбъектXDTO[ИмяСвойстваОбъекта].name) Тогда
		Форма[ИмяРеквизита] = ОбъектXDTO[ИмяСвойстваОбъекта].name;
		Форма[ИмяРеквизита + "ID"] = ОбъектXDTO[ИмяСвойстваОбъекта].objectId.id;
		Форма[ИмяРеквизита + "Тип"] = ОбъектXDTO[ИмяСвойстваОбъекта].objectId.type;	
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьНовыйБизнесПроцесс(Тип, ПредметБизнесПроцесса)
	
	Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();
	Запрос = СоздатьОбъект(Прокси, "DMGetNewBusinessProcessRequest");
		
	Запрос.type = Тип;
	Запрос.targetID = СоздатьОбъект(Прокси, "DMObjectID");
	Запрос.targetID.id = ПредметБизнесПроцесса.id;
	Запрос.targetID.type = ПредметБизнесПроцесса.type;
	
	Ответ = Прокси.execute(Запрос);
	ПроверитьВозвратВебСервиса(Прокси, Ответ);

	Если ПроверитьТип(Прокси, Ответ, "DMGetNewBusinessProcessResponse") Тогда
		Возврат Ответ.object;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции


///////////////////////////////////////////////////////
//// Общие процедуры и функции

// проверить код возврата
Процедура ПроверитьВозвратВебСервиса(Прокси, Ответ) Экспорт
	
	Если ПроверитьТип(Прокси, Ответ, "DMError") Тогда 
		ВызватьИсключение Ответ.subject + ":" + Символы.ПС + Символы.ПС + Ответ.description;
	КонецЕсли;	
	
КонецПроцедуры

// получает набор дополнительных реквизитов объекта и помещает его на форму объекта
Процедура ПолучитьДополнительныеРеквизитыИПоместитьНаФорму(Форма) Экспорт
	
	Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();
	
	Объект = СоздатьОбъект(Прокси, Форма.Тип);
	Объект.name = Форма.ЗаголовокДокумента;
	Объект.objectId = СоздатьОбъект(Прокси, "DMObjectID");
	Объект.objectId.id = Форма.ID;
	Объект.objectId.type = Форма.Тип;
	
	Если ЗначениеЗаполнено(Форма.ВидДокумента) Тогда
		Объект.DocumentType = СоздатьОбъект(Прокси, Форма.Тип + "Type");
		Объект.DocumentType.name = Форма.ВидДокумента;
		Объект.DocumentType.objectId = СоздатьОбъект(Прокси, "DMObjectID");
		Объект.DocumentType.objectId.id = Форма.ВидДокументаID;
		Объект.DocumentType.objectId.type = Форма.ВидДокументаТип;
	КонецЕсли;
		
	Запрос = СоздатьОбъект(Прокси, "DMGetObjectAdditionalPropertiesRequest");
	Запрос.object = Объект;
	
	Результат = Прокси.execute(Запрос);
	ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	ПоместитьДополнительныеРеквизитыНаФорму(Форма, Результат);
	
КонецПроцедуры

// помещает набор дополнительных реквизитов объекта на форму объекта
Процедура ПоместитьДополнительныеРеквизитыНаФорму(Форма, ОбъектXDTO) Экспорт
	
	Форма.Элементы.ГруппаСвойства.Видимость = Ложь;
	Если ОбъектXDTO.additionalProperties.Количество() > 0 Тогда
		Форма.Элементы.ГруппаСвойства.Видимость = Истина;
		Форма.Свойства.Очистить();
		Для Каждого ДопСвойство Из ОбъектXDTO.additionalProperties Цикл
			НоваяСтрока = Форма.Свойства.Добавить();
			
			НоваяСтрока.Свойство = ДопСвойство.name;
			НоваяСтрока.СвойствоТип = ДопСвойство.objectId.type;
			НоваяСтрока.СвойствоID = ДопСвойство.objectId.id;
			
			Если ДопСвойство.Установлено("propertySimpleValue") Тогда
				НоваяСтрока.Значение = ДопСвойство.propertySimpleValue;
			ИначеЕсли ДопСвойство.Установлено("propertyObjectValue") Тогда
                НоваяСтрока.Значение = ДопСвойство.propertyObjectValue.name;
				НоваяСтрока.ЗначениеТип = ДопСвойство.propertyObjectValue.objectId.type;
				НоваяСтрока.ЗначениеID = ДопСвойство.propertyObjectValue.objectId.id;
			КонецЕсли;
			
			Для Каждого ОписаниеТипа Из ДопСвойство.PropertyValueTypes Цикл
				ДанныеОТипе = Новый Структура("xdtoClassName, presentation");
				ДанныеОТипе.xdtoClassName = ОписаниеТипа.xdtoClassName;
				ДанныеОТипе.presentation = ОписаниеТипа.presentation;
				НоваяСтрока.СписокДоступныхТипов.Добавить(ДанныеОТипе);
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// помещает значения дополнительных свойств объекта с формы объекта в объект XDTO
Процедура СформироватьДополнительныеСвойства(Прокси, Форма, ОбъектXDTO) Экспорт
	
	Для Каждого ДопСвойство Из Форма.Свойства Цикл

		ДополнительноеСвойство = СоздатьОбъект(Прокси, "DMAdditionalProperty");
		ДополнительноеСвойство.name = ДопСвойство.Свойство;
		ДополнительноеСвойство.objectId = СоздатьObjectID(Прокси, ДопСвойство.СвойствоID, ДопСвойство.СвойствоТип);
		
		Если ЗначениеЗаполнено(ДопСвойство.Значение) Тогда
			Если ЗначениеЗаполнено(ДопСвойство.ЗначениеID) Тогда //значение объектного типа
				
				ДоступныеТипы = ДопСвойство.СписокДоступныхТипов;
				Если ДоступныеТипы.Количество() > 1 Тогда 
					ДополнительноеСвойство.propertyObjectValue = СоздатьОбъект(Прокси, "DMObject");
					ДополнительноеСвойство.propertyObjectValue.name = ДопСвойство.Значение;
					ДополнительноеСвойство.propertyObjectValue.objectId = СоздатьObjectID(Прокси, ДопСвойство.ЗначениеID, ДопСвойство.ЗначениеТип);
				Иначе
					ТипСвойства = ДоступныеТипы[0].Значение.xdtoClassName;
					ЗначениеСвойства = СоздатьОбъект(Прокси, ТипСвойства);
					
					// заполнить из потребителя
					РеквизитТип = ДопСвойство.ЗначениеТип;
					РеквизитID = ДопСвойство.ЗначениеID;
					Если Метаданные.НайтиПоПолномуИмени(РеквизитТип) <> Неопределено Тогда 
						РеквизитТип = СтрЗаменить(РеквизитТип, "Справочник.", 				"Справочники.");
						РеквизитТип = СтрЗаменить(РеквизитТип, "Документ.",					"Документы.");
						РеквизитТип = СтрЗаменить(РеквизитТип, "Задача.", 					"Задачи.");
						РеквизитТип = СтрЗаменить(РеквизитТип, "БизнесПроцесс.", 			"БизнесПроцессы.");
						РеквизитТип = СтрЗаменить(РеквизитТип, "ПланВидовХарактеристик.", 	"ПланыВидовХарактеристик.");
				
						СсылкаНаПотребителя = Неопределено;
						Выполнить("СсылкаНаПотребителя = " + РеквизитТип + ".ПолучитьСсылку(Новый УникальныйИдентификатор(РеквизитID))");
						
				 		ЗаполнитьРеквизитыИзПотребителя(Прокси, ЗначениеСвойства, СсылкаНаПотребителя);
				
					ИначеЕсли РеквизитТип = "Строка" Тогда 
				
						ЗначениеСвойства.objectId = СоздатьObjectID(Прокси, "", "");
						ЗначениеСвойства.name = ДопСвойство.Значение;
	
						ВнешнийИД = СоздатьОбъект(Прокси, "externalObject");
						ВнешнийИД.id = "";
						ВнешнийИД.type = "";
						ВнешнийИД.name = "";
						
						ЗначениеСвойства.externalObject = ВнешнийИД;	
				
					Иначе
				
						ЗначениеСвойства.objectId = СоздатьObjectID(Прокси, ДопСвойство.ЗначениеID, ДопСвойство.ЗначениеТип); 
						ЗначениеСвойства.name = ДопСвойство.Значение;
				
					КонецЕсли;
					
					ДополнительноеСвойство.propertyObjectValue = ЗначениеСвойства;
					
					
				КонецЕсли;	
					
			Иначе //значение примитивного вида
				ДополнительноеСвойство.propertySimpleValue = ДопСвойство.Значение;
			КонецЕсли;
		КонецЕсли;
		
		ОбъектXDTO.additionalProperties.Добавить(ДополнительноеСвойство);

	КонецЦикла;
	
КонецПроцедуры

// Создает XDTO объект указанного типа из пространства имен "http://www.1c.ru/dm"
Функция СоздатьОбъект(Прокси, ТипОбъекта) Экспорт
	
	Возврат Прокси.ФабрикаXDTO.Создать(Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/dm", ТипОбъекта));
	
КонецФункции

// Создает объект DMObjectID
Функция СоздатьObjectID(Прокси, id, type) Экспорт 
	
	objectId = СоздатьОбъект(Прокси, "DMObjectID");
	objectId.id = id;
	objectId.type = type;
	
	Возврат objectId;
	
КонецФункции	

// Проверяет тип объекта XDTO
// Возвращает Истина если объект является объектом указанного типа и Ложь в
// противном случае
Функция ПроверитьТип(Прокси, ОбъектXDTO, Тип) Экспорт 
	
	Если ОбъектXDTO.Тип() = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/dm", Тип) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает имя значения перечисления
Функция ИмяЗначенияПеречисления(Значение) Экспорт
	
	ОбъектМетаданных = Значение.Метаданные();
	
	ИндексЗначения = Перечисления[ОбъектМетаданных.Имя].Индекс(Значение);
	
	Возврат ОбъектМетаданных.ЗначенияПеречисления[ИндексЗначения].Имя;
	
КонецФункции 

Функция ЕстьУникальныйИдентификатор(Значение)
	
	Тип = ТипЗнч(Значение);
	
	Возврат Справочники.ТипВсеСсылки().СодержитТип(Тип)
		ИЛИ Документы.ТипВсеСсылки().СодержитТип(Тип)
		ИЛИ ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(Тип)
		ИЛИ БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип)
		ИЛИ Задачи.ТипВсеСсылки().СодержитТип(Тип);
	
КонецФункции	

// Выполняет действия при изменении вида документа
Процедура ПриИзмененииВидаНаФормеДокумента(Форма) Экспорт 
	
	ВидДокументаID = Форма.ВидДокументаID;
	ВидДокументаТип = Форма.ВидДокументаТип;
	
	ИмяФормы = Форма.ИмяФормы;
	Элементы = Форма.Элементы;
	
	Если ЗначениеЗаполнено(ВидДокументаID) И ЗначениеЗаполнено(ВидДокументаТип) Тогда 
		Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();
		ОбъектИд = СоздатьObjectID(Прокси, ВидДокументаID, ВидДокументаТип);
		
		Запрос = СоздатьОбъект(Прокси, "DMRetrieveRequest");
		Запрос.objectIds.Добавить(ОбъектИд);
		
		Результат = Прокси.execute(Запрос);
		РаботаС1СДокументооборотВызовСервера.ПроверитьВозвратВебСервиса(Прокси, Результат);	
	
		DocumentType = Результат.objects[0];
	Иначе	
		DocumentType = Неопределено;
	КонецЕсли;	
	
	Если ИмяФормы = "ОбщаяФорма.ДокументооборотВходящийДокумент" Тогда 
		
		Элементы.СрокИсполнения.Видимость = (DocumentType <> Неопределено И DocumentType.performanceDateEnabled = Истина); 
		Элементы.Сумма.Видимость 		  = (DocumentType <> Неопределено И DocumentType.sumEnabled = Истина); 
		Элементы.Валюта.Видимость 		  = (DocumentType <> Неопределено И DocumentType.sumEnabled = Истина); 
		
	ИначеЕсли ИмяФормы = "ОбщаяФорма.ДокументооборотИсходящийДокумент" Тогда 
		
		Элементы.СрокИсполнения.Видимость 	  = (DocumentType <> Неопределено И DocumentType.PerformanceDateEnabled = Истина); 
		Элементы.НомерПолучателя.Видимость    = (DocumentType <> Неопределено И DocumentType.ExternalNumberEnabled = Истина); 
		Элементы.ДатаПолучателя.Видимость 	  = (DocumentType <> Неопределено И DocumentType.ExternalNumberEnabled = Истина); 
		Элементы.Сумма.Видимость 		  	  = (DocumentType <> Неопределено И DocumentType.SumEnabled = Истина); 
		Элементы.Валюта.Видимость 		  	  = (DocumentType <> Неопределено И DocumentType.SumEnabled = Истина); 
		
	ИначеЕсли ИмяФормы = "ОбщаяФорма.ДокументооборотВнутреннийДокумент" Тогда 
		
		Элементы.СрокИсполнения.Видимость 	  = (DocumentType <> Неопределено И DocumentType.performanceDateEnabled = Истина); 
		Элементы.Корреспондент.Видимость  	  = (DocumentType <> Неопределено И DocumentType.correspondentEnabled = Истина); 
		Элементы.КонтактноеЛицо.Видимость 	  = (DocumentType <> Неопределено И DocumentType.correspondentEnabled = Истина); 
		Элементы.Сумма.Видимость 		  	  = (DocumentType <> Неопределено И DocumentType.sumEnabled = Истина); 
		Элементы.Валюта.Видимость 		  	  = (DocumentType <> Неопределено И DocumentType.sumEnabled = Истина); 
		Элементы.Бессрочный.Видимость 	  	  = (DocumentType <> Неопределено И DocumentType.durationEnabled = Истина); 
		Элементы.ПорядокПродления.Видимость   = (DocumentType <> Неопределено И DocumentType.durationEnabled = Истина); 
		Элементы.ДатаНачалаДействия.Видимость = (DocumentType <> Неопределено И DocumentType.durationEnabled = Истина); 
		Элементы.ДатаОкончанияДействия.Видимость = (DocumentType <> Неопределено И DocumentType.durationEnabled = Истина); 
		
	КонецЕсли;	
	
	АвтоматическаяНумерация = (DocumentType <> Неопределено И DocumentType.automaticNumeration = Истина);
	Если АвтоматическаяНумерация Тогда 
		Элементы.РегистрационныйНомер.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
		Элементы.ДатаРегистрации.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
		Элементы.Зарегистрировать.Доступность = Истина;
	Иначе
		Элементы.РегистрационныйНомер.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
		Элементы.ДатаРегистрации.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
		Элементы.Зарегистрировать.Доступность = Ложь;
	КонецЕсли;
	
	//установка дополнительных реквизитов
	ПолучитьДополнительныеРеквизитыИПоместитьНаФорму(Форма);
	
КонецПроцедуры	

// Возвращает соответствие свойств XDTO и реквизитов формы документа
Функция СоответсвиеСвойствXDTOиРеквизитовФормыДокумента(ИмяФормы) Экспорт 
	
	СоответствиеРеквизитов = Новый Структура;
	
	Если ИмяФормы = "ОбщаяФорма.ДокументооборотВходящийДокумент" Тогда 
		
		СоответствиеРеквизитов.Вставить("externalNumber",  	"НомерОтправителя");
		СоответствиеРеквизитов.Вставить("externalDate", 	"ДатаОтправителя");
		
		СоответствиеРеквизитов.Вставить("title", 		  	"ЗаголовокДокумента");
		СоответствиеРеквизитов.Вставить("summary", 		  	"Описание");
		СоответствиеРеквизитов.Вставить("comment", 		  	"Комментарий");
		СоответствиеРеквизитов.Вставить("regNumber", 	  	"РегистрационныйНомер");
		СоответствиеРеквизитов.Вставить("regDate", 		  	"ДатаРегистрации");
		СоответствиеРеквизитов.Вставить("performanceDate", 	"СрокИсполнения");
		СоответствиеРеквизитов.Вставить("sum", 			  	"Сумма");
		
		СоответствиеРеквизитов.Вставить("correspondent", 	"Отправитель");
		СоответствиеРеквизитов.Вставить("signer", 			"Подписал");
		СоответствиеРеквизитов.Вставить("addressee", 		"Адресат");
		СоответствиеРеквизитов.Вставить("subdivision", 		"Подразделение");
		СоответствиеРеквизитов.Вставить("accessLevel", 		"ГрифДоступа");
		СоответствиеРеквизитов.Вставить("documentType",  	"ВидДокумента");
		
		СоответствиеРеквизитов.Вставить("deliveryMethod",	"СпособПолучения");
		СоответствиеРеквизитов.Вставить("status", 			"Состояние");
		СоответствиеРеквизитов.Вставить("organization", 	"Организация");
		СоответствиеРеквизитов.Вставить("activityMatter", 	"ВопросДеятельности");
		СоответствиеРеквизитов.Вставить("responsible", 		"Ответственный");
		СоответствиеРеквизитов.Вставить("currency", 		"Валюта");
		
	ИначеЕсли ИмяФормы = "ОбщаяФорма.ДокументооборотИсходящийДокумент" Тогда 
		
		СоответствиеРеквизитов.Вставить("externalNumber", 	"НомерПолучателя");
		СоответствиеРеквизитов.Вставить("externalDate", 	"ДатаПолучателя");
		СоответствиеРеквизитов.Вставить("title", 			"ЗаголовокДокумента");
		СоответствиеРеквизитов.Вставить("summary", 			"Описание");
		СоответствиеРеквизитов.Вставить("comment", 			"Комментарий");
		СоответствиеРеквизитов.Вставить("regNumber", 		"РегистрационныйНомер");
		СоответствиеРеквизитов.Вставить("regDate", 			"ДатаРегистрации");
		СоответствиеРеквизитов.Вставить("performanceDate", 	"СрокИсполнения");
		СоответствиеРеквизитов.Вставить("sum", 				"Сумма");
		СоответствиеРеквизитов.Вставить("sent", 			"Отправлен");
		СоответствиеРеквизитов.Вставить("sendDate", 		"ДатаОтправки");
		
		СоответствиеРеквизитов.Вставить("correspondent", 	"Получатель");
		СоответствиеРеквизитов.Вставить("addressee", 		"Адресат");
		СоответствиеРеквизитов.Вставить("signer", 			"Подписал");
		СоответствиеРеквизитов.Вставить("author", 		  	"Подготовил");
		СоответствиеРеквизитов.Вставить("subdivision", 		"Подразделение");
		СоответствиеРеквизитов.Вставить("accessLevel", 		"ГрифДоступа");
		СоответствиеРеквизитов.Вставить("documentType",  	"ВидДокумента");
		СоответствиеРеквизитов.Вставить("deliveryMethod",	"СпособОтправки");
		СоответствиеРеквизитов.Вставить("status", 			"Состояние");
		СоответствиеРеквизитов.Вставить("organization", 	"Организация");
		СоответствиеРеквизитов.Вставить("activityMatter", 	"ВопросДеятельности");
		СоответствиеРеквизитов.Вставить("responsible", 		"Ответственный");
		СоответствиеРеквизитов.Вставить("currency", 		"Валюта");
		
	ИначеЕсли ИмяФормы = "ОбщаяФорма.ДокументооборотВнутреннийДокумент" Тогда 
		
		СоответствиеРеквизитов.Вставить("title", 		  	"ЗаголовокДокумента");
		СоответствиеРеквизитов.Вставить("summary", 		  	"Описание");
		СоответствиеРеквизитов.Вставить("comment", 		  	"Комментарий");
		СоответствиеРеквизитов.Вставить("regNumber", 	  	"РегистрационныйНомер");
		СоответствиеРеквизитов.Вставить("regDate", 		  	"ДатаРегистрации");
		СоответствиеРеквизитов.Вставить("performanceDate",	"СрокИсполнения");
		СоответствиеРеквизитов.Вставить("sum", 		  	  	"Сумма");
		СоответствиеРеквизитов.Вставить("beginDate", 	  	"ДатаНачалаДействия");
		СоответствиеРеквизитов.Вставить("endDate", 		  	"ДатаОкончанияДействия");
		СоответствиеРеквизитов.Вставить("openEnded", 	  	"Бессрочный");
		
		СоответствиеРеквизитов.Вставить("folder", 		  	"Папка");
		СоответствиеРеквизитов.Вставить("author", 		  	"Подготовил");
		СоответствиеРеквизитов.Вставить("signer", 		  	"Подписал");
		СоответствиеРеквизитов.Вставить("subdivision", 	  	"Подразделение");
		СоответствиеРеквизитов.Вставить("correspondent",  	"Корреспондент");
		СоответствиеРеквизитов.Вставить("contactPerson",  	"КонтактноеЛицо");
		СоответствиеРеквизитов.Вставить("prolongationProcedure","ПорядокПродления");
		СоответствиеРеквизитов.Вставить("accessLevel", 	  	"ГрифДоступа");
		СоответствиеРеквизитов.Вставить("documentType",   	"ВидДокумента");
		СоответствиеРеквизитов.Вставить("status", 		  	"Состояние");
		СоответствиеРеквизитов.Вставить("organization",   	"Организация");
		СоответствиеРеквизитов.Вставить("activityMatter", 	"ВопросДеятельности");
		СоответствиеРеквизитов.Вставить("responsible", 	  	"Ответственный");
		СоответствиеРеквизитов.Вставить("currency", 		 "Валюта");
		
	КонецЕсли;	
	
	Возврат СоответствиеРеквизитов;
	
КонецФункции	

// Заполняет реквизиты формы из данных объекта-потребителя
Процедура ЗаполнитьФормуИзПотребителя(ВнешнийОбъект, Форма) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ссылка
	|ИЗ
	|	Справочник.НастройкиЗаполненияОбъектов1СДокументооборота
	|ГДЕ
	|	ТипОбъектаПотребителя = &ТипОбъектаПотребителя
	|	И ТипОбъектаДокументооборота = &ТипОбъектаДокументооборота
	|	И Не ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ТипОбъектаПотребителя", ВнешнийОбъект.Метаданные().ПолноеИмя());
	Запрос.УстановитьПараметр("ТипОбъектаДокументооборота", Форма.Тип);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Форма["ЗаголовокДокумента"] = Строка(ВнешнийОбъект);
		Возврат;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	НастройкаЗаполнения = Выборка.Ссылка;
	
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИмяРеквизитаОбъектаДокументооборота", "DocumentType");
	ПараметрыОтбора.Вставить("ВариантПравилаЗаполненияРеквизитов", 	Перечисления.ВариантыПравилЗаполненияРеквизитов.ИзУказанногоЗначения);
	ПараметрыОтбора.Вставить("ДополнительныйРеквизит", 				Ложь);
	
	СтрокиВидДокумента = НастройкаЗаполнения.ПравилаЗаполненияРеквизитов.НайтиСтроки(ПараметрыОтбора);
	Если СтрокиВидДокумента.Количество() > 0 Тогда 
		СтрокаВидДокумента = СтрокиВидДокумента[0];
		
		ПараметрыЗаполнения = Новый Структура;
		ПараметрыЗаполнения.Вставить("DocumentType",
			Новый Структура("ID, Тип, Представление", 
			СтрокаВидДокумента.ИдентификаторЗначенияРеквизита,
			СтрокаВидДокумента.ТипЗначенияРеквизита,
			СтрокаВидДокумента.ЗначениеРеквизитаДокументооборота));
		
		Реквизиты = Справочники.НастройкиЗаполненияОбъектов1СДокументооборота.
			ПолучитьРеквизитыОбъектаДокументооборота(НастройкаЗаполнения.ТипОбъектаДокументооборота, ПараметрыЗаполнения);
		
	Иначе		
		
		Реквизиты = Справочники.НастройкиЗаполненияОбъектов1СДокументооборота.
			ПолучитьРеквизитыОбъектаДокументооборота(НастройкаЗаполнения.ТипОбъектаДокументооборота);
		
	КонецЕсли;	
		
		
	СоответствиеРеквизитов = СоответсвиеСвойствXDTOиРеквизитовФормыДокумента(Форма.ИмяФормы);
		
	Для Каждого Реквизит Из Реквизиты Цикл
		
		Если Не Реквизит.ДопРеквизит Тогда 
			ПараметрыОтбора = Новый Структура("ДополнительныйРеквизит, ИмяРеквизитаОбъектаДокументооборота", Ложь, Реквизит.Имя);
		Иначе
			ПараметрыОтбора = Новый Структура("ДополнительныйРеквизит, ДополнительныйРеквизитID, ДополнительныйРеквизитТип", Истина, Реквизит.ДопРеквизитID, Реквизит.ДопРеквизитТип);
		КонецЕсли;
		
		НайденныеСтроки = НастройкаЗаполнения.ПравилаЗаполненияРеквизитов.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 0 Тогда 
			Продолжить;
		КонецЕсли;	
		НайденнаяСтрока = НайденныеСтроки[0];
		
		
		Если Не Реквизит.ДопРеквизит Тогда 
			
			РеквизитФормы = СоответствиеРеквизитов[Реквизит.Имя];
			ТипРеквизита = Реквизит.Тип[0].Значение;
			
			Если НайденнаяСтрока.ВариантПравилаЗаполненияРеквизитов = Перечисления.ВариантыПравилЗаполненияРеквизитов.ИзРеквизитаОбъектаПотребителя Тогда 
				
				ИмяРеквизитаОбъектаПотребителя = НайденнаяСтрока.ИмяРеквизитаОбъектаПотребителя;
				Если ИмяРеквизитаОбъектаПотребителя = "Представление" Тогда 
					Результат = Строка(ВнешнийОбъект);
				ИначеЕсли Найти(ИмяРеквизитаОбъектаПотребителя, ".") > 0 Тогда 
					Результат = Неопределено;
					Выполнить("Результат = ВнешнийОбъект." + ИмяРеквизитаОбъектаПотребителя)
				Иначе
					Результат = ВнешнийОбъект[ИмяРеквизитаОбъектаПотребителя];
				КонецЕсли;	
				
				Если ТипРеквизита = "Строка" Или ТипРеквизита = "Дата" Или ТипРеквизита = "Число" Или ТипРеквизита = "ДатаВремя" Или ТипРеквизита = "Булево" Тогда 
					Форма[РеквизитФормы] = Результат;
					
				ИначеЕсли ЗначениеЗаполнено(Результат) Тогда 
					Форма[РеквизитФормы] = Строка(Результат);
					Если ЕстьУникальныйИдентификатор(Результат) Тогда 
						Форма[РеквизитФормы + "ID"] = Строка(Результат.УникальныйИдентификатор());
						Форма[РеквизитФормы + "Тип"] = Результат.Метаданные().ПолноеИмя();
					Иначе
						Форма[РеквизитФормы + "Тип"] = "Строка";
					КонецЕсли;	
				КонецЕсли;
				
			ИначеЕсли НайденнаяСтрока.ВариантПравилаЗаполненияРеквизитов = Перечисления.ВариантыПравилЗаполненияРеквизитов.ИзУказанногоЗначения Тогда
				
				Если ТипРеквизита = "Строка" Или ТипРеквизита = "Дата" Или ТипРеквизита = "Число" Или ТипРеквизита = "ДатаВремя" Или ТипРеквизита = "Булево" Тогда 
					Форма[РеквизитФормы] = НайденнаяСтрока.ЗначениеРеквизитаДокументооборота;
				Иначе
					Форма[РеквизитФормы] = НайденнаяСтрока.ЗначениеРеквизитаДокументооборота;
					Форма[РеквизитФормы + "ID"]  = НайденнаяСтрока.ИдентификаторЗначенияРеквизита;
					Форма[РеквизитФормы + "Тип"] = НайденнаяСтрока.ТипЗначенияРеквизита;
					
					Если Реквизит.Имя = "documentType" Тогда 
						ПриИзмененииВидаНаФормеДокумента(Форма);
					КонецЕсли;	
				КонецЕсли;
				
			ИначеЕсли НайденнаяСтрока.ВариантПравилаЗаполненияРеквизитов = Перечисления.ВариантыПравилЗаполненияРеквизитов.ИзВыраженияНаВстроенномЯзыке Тогда	
				
				Источник = ВнешнийОбъект;
				Результат = Неопределено;
				
				Выполнить(НайденнаяСтрока.ВычисляемоеВыражение);
				
				Если ТипРеквизита = "Строка" Или ТипРеквизита = "Дата" Или ТипРеквизита = "Число" Или ТипРеквизита = "ДатаВремя" Или ТипРеквизита = "Булево" Тогда 
					Форма[РеквизитФормы] = Результат;
					
				ИначеЕсли ЗначениеЗаполнено(Результат) Тогда 
					Форма[РеквизитФормы] = Строка(Результат);
					Если ЕстьУникальныйИдентификатор(Результат) Тогда 
						Форма[РеквизитФормы + "ID"] = Строка(Результат.УникальныйИдентификатор());
						Форма[РеквизитФормы + "Тип"] = Результат.Метаданные().ПолноеИмя();
					Иначе
						Форма[РеквизитФормы + "Тип"] = "Строка";
					КонецЕсли;	
				КонецЕсли;	
				
			КонецЕсли;	
			
		Иначе
			
			ТипРеквизита = Реквизит.Тип[0].Значение;			
			
			ПараметрыОтбора = Новый Структура("СвойствоТип, СвойствоID", Реквизит.ДопРеквизитТип, Реквизит.ДопРеквизитID);
			СтрокиДопРеквизита = Форма.Свойства.НайтиСтроки(ПараметрыОтбора);
			Если СтрокиДопРеквизита.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			СтрокаДопРеквизита = СтрокиДопРеквизита[0];
			
			Если НайденнаяСтрока.ВариантПравилаЗаполненияРеквизитов = Перечисления.ВариантыПравилЗаполненияРеквизитов.ИзРеквизитаОбъектаПотребителя Тогда 
				
				ИмяРеквизитаОбъектаПотребителя = НайденнаяСтрока.ИмяРеквизитаОбъектаПотребителя;
				Если ИмяРеквизитаОбъектаПотребителя = "Представление" Тогда 
					Результат = Строка(ВнешнийОбъект);
				ИначеЕсли Найти(ИмяРеквизитаОбъектаПотребителя, ".") > 0 Тогда 
					Результат = Неопределено;
					Выполнить("Результат = ВнешнийОбъект." + ИмяРеквизитаОбъектаПотребителя)
				Иначе
					Результат = ВнешнийОбъект[ИмяРеквизитаОбъектаПотребителя];
				КонецЕсли;	
				
				Если ТипРеквизита = "Строка" Или ТипРеквизита = "Дата" Или ТипРеквизита = "Число" Или ТипРеквизита = "ДатаВремя" Или ТипРеквизита = "Булево" Тогда 
					СтрокаДопРеквизита["Значение"] = Результат;
					
				ИначеЕсли ЗначениеЗаполнено(Результат) Тогда 
					СтрокаДопРеквизита["Значение"] = Строка(Результат);
					Если ЕстьУникальныйИдентификатор(Результат) Тогда 
						СтрокаДопРеквизита["ЗначениеID"] = Строка(Результат.УникальныйИдентификатор());
						СтрокаДопРеквизита["ЗначениеТип"] = Результат.Метаданные().ПолноеИмя();
					Иначе
						СтрокаДопРеквизита["ЗначениеТип"] = "Строка";
					КонецЕсли;	
				КонецЕсли;	
				
			ИначеЕсли НайденнаяСтрока.ВариантПравилаЗаполненияРеквизитов = Перечисления.ВариантыПравилЗаполненияРеквизитов.ИзУказанногоЗначения Тогда
				
				СтрокаДопРеквизита["Значение"] = НайденнаяСтрока.ЗначениеРеквизитаДокументооборота;
				СтрокаДопРеквизита["ЗначениеID"]  = НайденнаяСтрока.ИдентификаторЗначенияРеквизита;
				СтрокаДопРеквизита["ЗначениеТип"] = НайденнаяСтрока.ТипЗначенияРеквизита;
				
			ИначеЕсли НайденнаяСтрока.ВариантПравилаЗаполненияРеквизитов = Перечисления.ВариантыПравилЗаполненияРеквизитов.ИзВыраженияНаВстроенномЯзыке Тогда	
				
				Источник = ВнешнийОбъект;
				Результат = Неопределено;
				
				Выполнить(НайденнаяСтрока.ВычисляемоеВыражение);
				
				Если ТипРеквизита = "Строка" Или ТипРеквизита = "Дата" Или ТипРеквизита = "Число" Или ТипРеквизита = "ДатаВремя" Или ТипРеквизита = "Булево" Тогда 
					СтрокаДопРеквизита["Значение"] = Результат;
					
				ИначеЕсли ЗначениеЗаполнено(Результат) Тогда 
					СтрокаДопРеквизита["Значение"] = Строка(Результат);
					Если ЕстьУникальныйИдентификатор(Результат) Тогда 
						СтрокаДопРеквизита["ЗначениеID"] = Строка(Результат.УникальныйИдентификатор());
						СтрокаДопРеквизита["ЗначениеТип"] = Результат.Метаданные().ПолноеИмя();
					Иначе	
						СтрокаДопРеквизита["ЗначениеТип"] = "Строка";
					КонецЕсли;	
				КонецЕсли;	
				
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЦикла;		
		
КонецПроцедуры	

// Заполняет реквизиты из объекта потребителя
Процедура ЗаполнитьРеквизитыИзПотребителя(Прокси, РеквизитОбъектаXDTO, СсылкаНаПотребитель) Экспорт 
	
	РеквизитОбъектаXDTO.name = Строка(СсылкаНаПотребитель);
	РеквизитОбъектаXDTO.objectId = СоздатьObjectID(Прокси, "", "");
	
	ВнешнийОбъект = СоздатьОбъект(Прокси, "ExternalObject");
	ПолноеИмя = СсылкаНаПотребитель.Метаданные().ПолноеИмя();
	Если Найти(ПолноеИмя, "Перечисление.") > 0 Тогда 
		ВнешнийОбъект.id = ИмяЗначенияПеречисления(СсылкаНаПотребитель);
		ВнешнийОбъект.type = ПолноеИмя;
		ВнешнийОбъект.name = Строка(СсылкаНаПотребитель);
	Иначе
		ВнешнийОбъект.id = Строка(СсылкаНаПотребитель.УникальныйИдентификатор());
		ВнешнийОбъект.type = ПолноеИмя;
		ВнешнийОбъект.name = Строка(СсылкаНаПотребитель);
	КонецЕсли;	
	РеквизитОбъектаXDTO.externalObject = ВнешнийОбъект;
	
	РаботаС1СДокументооборотПереопределяемый.ЗаполнитьРеквизитыИзПотребителя(Прокси, РеквизитОбъектаXDTO, СсылкаНаПотребитель);
	
КонецПроцедуры	
