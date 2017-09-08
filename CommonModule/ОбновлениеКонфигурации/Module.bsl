﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление конфигурации"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Проверить, что запуск программы выполнен от имени внешнего пользователя 
// и выбросить исключение в этом случае.
//
// Параметры
//  ТекстСообщения  - Строка - текст исключения. Если не задан, 
//                             используется текст по умолчанию.
//
// Пример использования:
//    ПрерватьВыполнениеЕслиАвторизованВнешнийПользователь();
//    ... далее располагается фрагмент кода, который рассчитывает только на выполнение 
//        из-под "обычного" пользователя.
//
Процедура ПрерватьВыполнениеЕслиАвторизованВнешнийПользователь(Знач ТекстСообщения = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ЗначениеЗаполнено(Пользователи.ТекущийПользователь()) Тогда
		
		ТекстИсключения = ТекстСообщения;
		
		Если ПустаяСтрока(ТекстИсключения) Тогда
			ТекстИсключения = НСтр("ru = 'Данная операция не доступна внешнему пользователю системы.'");
		КонецЕсли;
		
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
КонецПроцедуры

// Получить глобальные настройки обновления на сеанс 1С:Предприятия
//
Функция ПолучитьНастройкиОбновления() Экспорт
	Настройки = Новый Структура;
	Настройки.Вставить("КороткоеИмяКонфигурации", КороткоеИмяКонфигурации());
	Настройки.Вставить("АдресСервераДляПроверкиНаличияОбновления", АдресСервераДляПроверкиНаличияОбновления());
	Настройки.Вставить("КаталогОбновлений", КаталогОбновлений());
	Настройки.Вставить("АдресРесурсаДляПроверкиНаличияОбновления", АдресРесурсаДляПроверкиНаличияОбновления());
	Настройки.Вставить("КонфигурацияИзменена", КонфигурацияИзменена());
	Настройки.Вставить("ПроверитьПрошлыеОбновленияБазы", ОбновлениеКонфигурацииУспешно() <> Неопределено);
	Настройки.Вставить("НастройкиОбновленияКонфигурации", ПолучитьСтруктуруНастроекПомощника());
	Настройки.Вставить("ЕстьДоступДляОбновления", ПроверитьДоступДляОбновления());
	Настройки.Вставить("ЕстьДоступДляПроверкиОбновления", ПроверитьДоступДляПроверкиОбновления());
	Возврат Настройки;
КонецФункции

// Вызывается при завершении обновления конфигурации через COM-соединение.
//
// Параметры
//  РезультатОбновления  – Булево – Результат обновления.
//
Процедура ЗавершитьОбновление(Знач РезультатОбновления, Знач ЭлектроннаяПочта, Знач ИмяАдминистратораОбновления) Экспорт

	ТекстСообщения = НСтр("ru = 'Завершение обновления из внешнего скрипта.'");
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,,ТекстСообщения);
	
	Если НЕ ПроверитьДоступДляОбновления() Тогда
		ТекстСообщения = НСтр("ru = 'Недостаточно прав для завершения обновления конфигурации.'");
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ЗаписатьСтатусОбновления(ИмяАдминистратораОбновления, Ложь, Истина, РезультатОбновления);
	
	Если НЕ ПустаяСтрока(ЭлектроннаяПочта) Тогда
		Попытка
			ОтправитьУведомлениеОбОбновлении(ИмяАдминистратораОбновления, ЭлектроннаяПочта, РезультатОбновления);
			ТекстСообщения = НСтр("ru = 'Уведомление об обновлении успешно отправлено на адрес электронной почты: '") + ЭлектроннаяПочта;
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,,ТекстСообщения);
		Исключение
			ТекстСообщения = НСтр("ru = 'Ошибка при отправке письма электронной почты:'") + ЭлектроннаяПочта + Символы.ПС + 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);
		КонецПопытки;	
	КонецЕсли;
	
КонецПроцедуры

// Получить короткое имя (идентификатор) конфигурации.
//
// Возвращаемое значение:
//   Строка   – короткое имя конфигурации.
Функция КороткоеИмяКонфигурации()
	
	Значение = ОбновлениеКонфигурацииПереопределяемый.КороткоеИмяКонфигурации() + "/";
	// Определение редакции конфигурации
	ПодстрокиВерсии = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Метаданные.Версия, ".");
	Если ПодстрокиВерсии.Количество() > 1 Тогда
		Значение = Значение + ПодстрокиВерсии[0] + ПодстрокиВерсии[1] + "/";
	КонецЕсли;
	// Определение версии платформы
	СисИнфо = Новый СистемнаяИнформация;
	ПодстрокиВерсии = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СисИнфо.ВерсияПриложения, ".");
	Значение = Значение + ПодстрокиВерсии[0] + ПодстрокиВерсии[1] + "/";
	
	СтруктураНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбновлениеКонфигурации", 
		"НастройкиОбновленияКонфигурации"
	);
		
	Если СтруктураНастройки <> Неопределено Тогда // Значение из настроек пользователя
		ИспользоватьЗначениеНастройки = Ложь;															
		СтруктураНастройки.Свойство("ИспользоватьЗначениеНастройкиКороткоеИмяКонфигурации", ИспользоватьЗначениеНастройки);
		Если ИспользоватьЗначениеНастройки = Истина Тогда
			Значение = СтруктураНастройки.КороткоеИмяКонфигурации;
		КонецЕсли;	
	КонецЕсли;	
	
	Возврат Значение;
	
КонецФункции

// Получить адрес веб-сервера поставщика конфигурации, на котором находится
// информация о доступных обновлениях.
//
// Возвращаемое значение:
//   Строка   – адрес веб-сервера.
//
// Пример реализации:
// 
//	Возврат "localhost";  // локальный веб-сервер для тестирования.
//
Функция АдресСервераДляПроверкиНаличияОбновления()
	
	Значение			= "downloads.1c.ru"; // Значение по умолчанию
	
	ЗначениеПереопределяемогоМодуля = ОбновлениеКонфигурацииПереопределяемый.АдресСервераДляПроверкиНаличияОбновления();
	Если НЕ ПустаяСтрока(ЗначениеПереопределяемогоМодуля) Тогда  // Переопределяемое значение
		Значение = ЗначениеПереопределяемогоМодуля;
	КонецЕсли;
	
	СтруктураНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	    "ОбновлениеКонфигурации",
	    "НастройкиОбновленияКонфигурации"
	);
															
	Если СтруктураНастройки <> Неопределено Тогда // Значение из настроек пользователя
		ИспользоватьЗначениеНастройки = Ложь;															
		СтруктураНастройки.Свойство("ИспользоватьЗначениеНастройкиАдресСервераДляПроверкиНаличияОбновления", ИспользоватьЗначениеНастройки);
		Если ИспользоватьЗначениеНастройки = Истина Тогда
			Значение = СтруктураНастройки.АдресСервераДляПроверкиНаличияОбновления;
		КонецЕсли;
	КонецЕсли;	
	
	Возврат Значение;
	
КонецФункции

Функция КаталогОбновлений()
	
	Значение = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Метаданные.АдресКаталогаОбновлений); // Значение по умолчанию
	
	ЗначениеПереопределяемогоМодуля = ОбновлениеКонфигурацииПереопределяемый.КаталогОбновлений();
	Если НЕ ПустаяСтрока(ЗначениеПереопределяемогоМодуля) Тогда  // Переопределяемое значение
		Значение = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ЗначениеПереопределяемогоМодуля);
	КонецЕсли;
	
	СтруктураНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбновлениеКонфигурации", 
		"НастройкиОбновленияКонфигурации"
	);
	
	Если СтруктураНастройки <> Неопределено Тогда // Значение из настроек пользователя
		ИспользоватьЗначениеНастройки = Ложь;															
		СтруктураНастройки.Свойство("ИспользоватьЗначениеНастройкиКаталогОбновлений", ИспользоватьЗначениеНастройки);
		Если ИспользоватьЗначениеНастройки = Истина Тогда
			Значение = СтруктураНастройки.КаталогОбновлений;
		КонецЕсли;
	КонецЕсли;	
	
	Возврат Значение;
	
КонецФункции

Функция АдресРесурсаДляПроверкиНаличияОбновления()
	
	Значение = "/ipp/ITSREPV/V8Update/Configs/";  // Значение по умолчанию
	
	ЗначениеПереопределяемогоМодуля = ОбновлениеКонфигурацииПереопределяемый.АдресРесурсаДляПроверкиНаличияОбновления();
	Если НЕ ПустаяСтрока(ЗначениеПереопределяемогоМодуля) Тогда  // Переопределяемое значение
		Значение = ЗначениеПереопределяемогоМодуля;
	КонецЕсли;
	
	СтруктураНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбновлениеКонфигурации",
		"НастройкиОбновленияКонфигурации"
	);
	
	Если СтруктураНастройки <> Неопределено Тогда // Значение из настроек пользователя
		ИспользоватьЗначениеНастройки = Ложь;															
		СтруктураНастройки.Свойство("ИспользоватьЗначениеНастройкиАдресРесурсаДляПроверкиНаличияОбновления", ИспользоватьЗначениеНастройки);
		Если ИспользоватьЗначениеНастройки = Истина Тогда
			Значение = СтруктураНастройки.АдресРесурсаДляПроверкиНаличияОбновления;
		КонецЕсли;	
	КонецЕсли;	
	
	Возврат Значение;
	
КонецФункции

// Возвращает признак успешного обновления конфигурации на основе данных константы настроек.
Функция ОбновлениеКонфигурацииУспешно() Экспорт

	Если НЕ ПравоДоступа("Чтение", Метаданные.Константы.СтатусОбновленияКонфигурации) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЗначениеХранилища = Константы.СтатусОбновленияКонфигурации.Получить();
	
	Статус = Неопределено;
	Если ЗначениеХранилища <> Неопределено Тогда
		Статус = ЗначениеХранилища.Получить();
	КонецЕсли;

	Если Статус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ Статус.ОбновлениеВыполнено ИЛИ 
		(Статус.ИмяАдминистратораОбновления <> ИмяПользователя()) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Статус.РезультатОбновленияКонфигурации;

КонецФункции

// Устанавливает новое значение в константу настроек обновления
// соответственно успешности последней попытки обновления конфигурации.
Процедура ЗаписатьСтатусОбновления(Знач ИмяАдминистратораОбновления = "", Знач ОбновлениеЗапланировано = Ложь,
	Знач ОбновлениеВыполнено = Ложь, Знач РезультатОбновления = Ложь, СообщенияДляЖурналаРегистрации = Неопределено) Экспорт

	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	Статус = Новый Структура("ИмяАдминистратораОбновления,
		 |ОбновлениеЗапланировано,
		 |ОбновлениеВыполнено,
		 |РезультатОбновленияКонфигурации",
		 ИмяАдминистратораОбновления,
		 ОбновлениеЗапланировано,
		 ОбновлениеВыполнено,
		 РезультатОбновления);
							 
	Константы.СтатусОбновленияКонфигурации.Установить(Новый ХранилищеЗначения(Статус));

КонецПроцедуры

// Выполняет очистку всех настроек обновления конфигурации.
Процедура СброситьСтатусОбновленияКонфигурации() Экспорт
	
	Константы.СтатусОбновленияКонфигурации.Установить(Новый ХранилищеЗначения(Неопределено));
	
КонецПроцедуры

// Получает из хранилища общих настроек настройки обновления конфигурации.
Функция ПолучитьСтруктуруНастроекПомощника() Экспорт
	
	Расписание = Неопределено;
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбновлениеКонфигурации", 
		"НастройкиОбновленияКонфигурации"
	);
	
	Если Настройки = Неопределено Тогда
		КоличествоСтарыхНастроек = 0;
	ИначеЕсли ТипЗнч(Настройки) = Тип("Структура") ИЛИ ТипЗнч(Настройки) = Тип("Соответствие") Тогда
		КоличествоСтарыхНастроек = Настройки.Количество();
	Иначе
		КоличествоСтарыхНастроек = 0;
	КонецЕсли;
	Настройки = ОбновлениеКонфигурацииКлиентСервер.ПолучитьОбновленныеНастройкиОбновленияКонфигурации(Настройки);
	// Если появились новые настройки, то их нужно сохранить
	Если Настройки.Количество() > КоличествоСтарыхНастроек Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЗаписатьСтруктуруНастроекПомощника(Настройки);	
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	// Если в ранних версиях было сохранено расписание, и еще не отработал обработчик
	// обновления ОбновлениеРасписанияПроверкиНаличияОбновления, то...
	Если Настройки <> Неопределено И Настройки.Свойство("РасписаниеПроверкиНаличияОбновления", Расписание) 
		И ТипЗнч(Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
		Настройки.РасписаниеПроверкиНаличияОбновления = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание);
	КонецЕсли; 
	Возврат Настройки;
	
КонецФункции

// Записывает настройки помощника обновления в хранилище общих настроек.
Процедура ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации, СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ОбновлениеКонфигурации", 
		"НастройкиОбновленияКонфигурации", 
		НастройкиОбновленияКонфигурации
	);
	
КонецПроцедуры
								 
// Проверка доступа к подсистеме ОбновлениеКонфигурации
Функция ПроверитьДоступДляОбновления()
	Возврат Пользователи.ЭтоПолноправныйПользователь(,Истина);
КонецФункции

// Возвращает признак доступности проведения обновления текущим пользователем.
Функция ПроверитьДоступДляПроверкиОбновления() Экспорт
	Возврат Пользователи.РолиДоступны("ПроверкаДоступныхОбновленийКонфигурации")
		И ЗначениеЗаполнено(Пользователи.ТекущийПользователь());
КонецФункции

Процедура ОтправитьУведомлениеОбОбновлении(Знач ИмяПользователя, Знач АдресНазначения, Знач УспешноеОбновление)
	
	Тема = ? (УспешноеОбновление, НСтр("ru = 'Успешное обновление конфигурации ""%1"", версия %2'"), 
		НСтр("ru = 'Ошибка обновления конфигурации ""%1"", версия %2'"));
	Тема = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Тема, Метаданные.КраткаяИнформация, Метаданные.Версия);
		
	Подробности = ?(УспешноеОбновление, НСтр("ru = 'Обновление конфигурации завершено успешно.'"), 
		НСтр("ru = 'При обновлении конфигурации произошли ошибки. Подробности записаны в журнал регистрации.'"));
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1
		|
		|Конфигурация: %2
		|Версия: %3
		|Строка соединения: %4'"),
		Подробности, Метаданные.КраткаяИнформация, Метаданные.Версия, СтрокаСоединенияИнформационнойБазы());
			
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Тема", Тема);
	ПараметрыПисьма.Вставить("Тело", Текст);
	ПараметрыПисьма.Вставить("Кому", АдресНазначения);
			
	РаботаСПочтовымиСообщениями.ОтправитьСообщение(РаботаСПочтовымиСообщениями.ПолучитьСистемнуюУчетнуюЗапись(), ПараметрыПисьма);
	
КонецПроцедуры

// Возвращает имя события для записи журнала регистрации.
Функция СобытиеЖурналаРегистрации() Экспорт
	Возврат НСтр("ru = 'Обновление конфигурации'");
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.8";
	Обработчик.Процедура = "ОбновлениеКонфигурации.ОбновлениеРасписанияПроверкиНаличияОбновления";
	
КонецПроцедуры

// Процедура-обработчик обновления.
//
Процедура ОбновлениеРасписанияПроверкиНаличияОбновления() Экспорт
	
	Расписание = Неопределено;
	СписокПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ТекущийПользователь Из СписокПользователей Цикл
		ИмяПользователя = ТекущийПользователь.Имя;
		
		Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ОбновлениеКонфигурации", 
			"НастройкиОбновленияКонфигурации",
			,
			,
			ИмяПользователя
		);
		
		// Если в ранних версиях было сохранено расписание...
		Если Настройки <> Неопределено И Настройки.Свойство("РасписаниеПроверкиНаличияОбновления", Расписание) 
			И ТипЗнч(Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
			
			Настройки.РасписаниеПроверкиНаличияОбновления = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание);
			
			ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
				"ОбновлениеКонфигурации", 
				"НастройкиОбновленияКонфигурации", 
				Настройки,
				,
				ИмяПользователя
			);
			
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры	
