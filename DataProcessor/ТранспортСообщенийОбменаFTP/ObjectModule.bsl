﻿Перем СтрокаСообщенияОбОшибке Экспорт;
Перем СтрокаСообщенияОбОшибкеЖР Экспорт;

Перем СообщенияОшибок; // соответствие с предопределенными сообщениями ошибок обработки
Перем ИмяОбъекта;		// имя объекта метаданных
Перем ИмяFTPСервера;		// Адрес FTP сервера - имя или ip адрес
Перем КаталогНаFTPСервере;// Каталог на сервере, для хранения/получения сообщений обмена

Перем ВременныйФайлСообщенияОбмена; // временный файл сообщения обмена для выгрузки/загрузки данных
Перем ВременныйКаталогСообщенийОбмена; // временный каталог для сообщений обмена

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции

// Создает временный каталог в каталоге временных файлов пользователя операционной системы.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина – удалось выполнить функцию, Ложь – произошла ошибка
// 
Функция ВыполнитьДействияПередОбработкойСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	Возврат СоздатьВременныйКаталогСообщенийОбмена();
	
КонецФункции

// Выполняет отправку сообщения обмена на заданный ресурс из временного каталога сообщения обмена
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина – удалось выполнить функцию, Ложь – произошла ошибка
// 
Функция ОтправитьСообщение() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		Результат = ОтправитьСообщениеОбмена();
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Получает сообщение обмена с заданного ресурса во временный каталог сообщения обмена
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина – удалось выполнить функцию, Ложь – произошла ошибка
// 
Функция ПолучитьСообщение() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		Результат = ПолучитьСообщениеОбмена();
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Удаляет временный каталог сообщений обмена после выполнения выгрузки или загрузки данных
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина
//
Функция ВыполнитьДействияПослеОбработкиСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	УдалитьВременныйКаталогСообщенийОбмена();
	
	Возврат Истина;
	
КонецФункции

// Выполняет проверку наличия сообщения обмена на заданном ресурсе
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - сообщение обмена присутствует на заданном ресурсе; Лож – нет
//
Функция ФайлСообщенияОбменаСуществует() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		FTPСоединение = ПолучитьFTPСоединение();
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		МассивНайденныхФайлов = FTPСоединение.НайтиФайлы(КаталогНаFTPСервере, ШаблонИмениФайлаСообщения + ".*", Ложь);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(104);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат МассивНайденныхФайлов.Количество() > 0;
	
КонецФункции

// Выполняет инициализацию свойств обработки начальными значениями и константами
//
// Параметры:
//  Нет.
// 
Процедура Инициализация() Экспорт
	
	ИнициализацияСообщений();
	
	ИмяСервераИКаталогНаСервере = РазделитьFTPРесурсНаСерверИКаталог(СокрЛП(FTPСоединениеПуть));
	ИмяFTPСервера			= ИмяСервераИКаталогНаСервере.ИмяСервера;
	КаталогНаFTPСервере	= ИмяСервераИКаталогНаСервере.ИмяКаталога;
	
КонецПроцедуры

// Выполняет проверку возможности установки подключения к заданному ресурсу
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево – Истина – подключение может быть установлено; Ложь – нет
//
Функция ПодключениеУстановлено() Экспорт
	
	// возвращаемое значение функции
	Результат = Истина;
	
	ИнициализацияСообщений();
	
	Если	ПустаяСтрока(FTPСоединениеПуть)
		ИЛИ FTPСоединениеПорт = 0
		ИЛИ ПустаяСтрока(FTPСоединениеПользователь) Тогда
		
		ПолучитьСообщениеОбОшибке(101);
		Возврат Ложь;
		
	КонецЕсли;
	
	// создаем файл во временном каталоге
	ИмяВременногоФайлаПроверкиПодключения = ПолучитьИмяВременногоФайла("tmp");
	ИмяФайлаНаСторонеПриемника = ОбменДаннымиСервер.ИмяФайлаПроверкиПодключения();
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайлаПроверкиПодключения);
	ЗаписьТекста.ЗаписатьСтроку(ИмяФайлаНаСторонеПриемника);
	ЗаписьТекста.Закрыть();
	
	// копируем файл на внешний ресурс из временного каталога
	Результат = ВыполнитьКопированиеФайлаНаFTPСервер(ИмяВременногоФайлаПроверкиПодключения, ИмяФайлаНаСторонеПриемника);
	
	// удаляем файл на внешнем ресурсе
	Если Результат Тогда
		
		Результат = ВыполнитьУдалениеФайлаНаFTPСервере(ИмяФайлаНаСторонеПриемника, Истина);
		
	КонецЕсли;
	
	// удаляем файл из временного каталога
	Попытка
		УдалитьФайлы(ИмяВременногоФайлаПроверкиПодключения);
	Исключение
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Функции-свойства

// Функция-свойство: время изменения файла сообщения обмена
//
// Тип: Дата
//
Функция ДатаФайлаСообщенияОбмена() Экспорт
	
	Результат = Неопределено;
	
	Если ТипЗнч(ВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Если ВременныйФайлСообщенияОбмена.Существует() Тогда
			
			Результат = ВременныйФайлСообщенияОбмена.ПолучитьВремяИзменения();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция-свойство: полное имя файла сообщения обмена
//
// Тип: Строка
//
Функция ИмяФайлаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(ВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Имя = ВременныйФайлСообщенияОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

// Функция-свойство: полное имя каталога сообщения обмена
//
// Тип: Строка
//
Функция ИмяКаталогаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(ВременныйКаталогСообщенийОбмена) = Тип("Файл") Тогда
		
		Имя = ВременныйКаталогСообщенийОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции

Функция СоздатьВременныйКаталогСообщенийОбмена()
	
	ВременныйКаталогСообщенийОбмена = Новый Файл(ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВременныхФайлов(), ОбменДаннымиСервер.ИмяВременногоКаталогаСообщенийОбмена()));
	
	// создаем временный каталог для сообщений обмена
	Попытка
		СоздатьКаталог(ИмяКаталогаСообщенияОбмена());
	Исключение
		ПолучитьСообщениеОбОшибке(4);
		ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
	ИмяФайлаСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".xml");
	
	ВременныйФайлСообщенияОбмена = Новый Файл(ИмяФайлаСообщения);
	
	Возврат Истина;
	
КонецФункции

Функция УдалитьВременныйКаталогСообщенийОбмена()
	
	Попытка
		Если Не ПустаяСтрока(ИмяКаталогаСообщенияОбмена()) Тогда
			УдалитьФайлы(ИмяКаталогаСообщенияОбмена());
			ВременныйКаталогСообщенийОбмена = Неопределено;
		КонецЕсли;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ОтправитьСообщениеОбмена()
	
	Результат = Истина;
	
	Расширение = ?(СжиматьФайлИсходящегоСообщения(), ".zip", ".xml");
	
	ИмяФайлаИсходящегоСообщения = ШаблонИмениФайлаСообщения + Расширение;
	
	Если СжиматьФайлИсходящегоСообщения() Тогда
		
		// получаем имя для временного файла архива
		ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
		
		Попытка
			
			Архиватор = Новый ЗаписьZipФайла(ИмяВременногоФайлаАрхива, ПарольАрхиваСообщенияОбмена, "Файл сообщения обмена");
			Архиватор.Добавить(ИмяФайлаСообщенияОбмена());
			Архиватор.Записать();
			
		Исключение
			
			Результат = Ложь;
			ПолучитьСообщениеОбОшибке(3);
			ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
		Архиватор = Неопределено;
		
		Если Результат Тогда
			
			// выполняем проверку на максимально допустимый размер сообщения обмена
			Если ОбменДаннымиСервер.РазмерСообщенияОбменаПревышаетДопустимый(ИмяВременногоФайлаАрхива, МаксимальныйДопустимыйРазмерСообщения()) Тогда
				ПолучитьСообщениеОбОшибке(108);
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат Тогда
			
			// копируем файл архива на FTP сервер в каталог обмена информацией
			Если Не ВыполнитьКопированиеФайлаНаFTPСервер(ИмяВременногоФайлаАрхива, ИмяФайлаИсходящегоСообщения) Тогда
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если Результат Тогда
			
			// выполняем проверку на максимально допустимый размер сообщения обмена
			Если ОбменДаннымиСервер.РазмерСообщенияОбменаПревышаетДопустимый(ИмяФайлаСообщенияОбмена(), МаксимальныйДопустимыйРазмерСообщения()) Тогда
				ПолучитьСообщениеОбОшибке(108);
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат Тогда
			
			// копируем файл архива на FTP сервер в каталог обмена информацией
			Если Не ВыполнитьКопированиеФайлаНаFTPСервер(ИмяФайлаСообщенияОбмена(), ИмяФайлаИсходящегоСообщения) Тогда
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСообщениеОбмена()
	
	ТаблицаФайловСообщенийОбмена = Новый ТаблицаЗначений;
	ТаблицаФайловСообщенийОбмена.Колонки.Добавить("Файл");
	ТаблицаФайловСообщенийОбмена.Колонки.Добавить("ВремяИзменения");
	
	Попытка
		FTPСоединение = ПолучитьFTPСоединение();
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		МассивНайденныхФайлов = FTPСоединение.НайтиФайлы(КаталогНаFTPСервере, ШаблонИмениФайлаСообщения + ".*", Ложь);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(104);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Для Каждого ТекущийФайл ИЗ МассивНайденныхФайлов Цикл
		
		// проверяем нужное расширение
		Если ((ВРег(ТекущийФайл.Расширение) <> ".ZIP")
			И (ВРег(ТекущийФайл.Расширение) <> ".XML")) Тогда
			
			Продолжить;
			
		// проверяем что это файл, а не каталог
		ИначеЕсли (ТекущийФайл.ЭтоФайл() = Ложь) Тогда
			
			Продолжить;
			
		// проверяем ненулевой размер файла
		ИначеЕсли (ТекущийФайл.Размер() = 0) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		// файл является требуемым сообщением обмена; добавляем его в таблицу
		СтрокаТаблицы = ТаблицаФайловСообщенийОбмена.Добавить();
		СтрокаТаблицы.Файл           = ТекущийФайл;
		СтрокаТаблицы.ВремяИзменения = ТекущийФайл.ПолучитьВремяИзменения();
		
	КонецЦикла;
	
	Если ТаблицаФайловСообщенийОбмена.Количество() = 0 Тогда
		
		ПолучитьСообщениеОбОшибке(1);
		
		СтрокаСообщения = НСтр("ru = 'Каталог обмена информацией на сервере: ""%1""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, КаталогНаFTPСервере);
		ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		
		СтрокаСообщения = НСтр("ru = 'Имя файла сообщения обмена: ""%1"" или ""%2""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ШаблонИмениФайлаСообщения + ".xml", ШаблонИмениФайлаСообщения + ".zip");
		ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		
		Возврат Ложь;
		
	Иначе
		
		ТаблицаФайловСообщенийОбмена.Сортировать("ВремяИзменения Убыв");
		
		// получаем из таблицы самый "свежий" файл сообщения обмена
		ФайлВходящегоСообщения = ТаблицаФайловСообщенийОбмена[0].Файл;
		
		ФайлЗапакован = (ВРег(ФайлВходящегоСообщения.Расширение) = ".ZIP");
		
		Если ФайлЗапакован Тогда
			
			// получаем имя для временного файла архива
			ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
			
			Попытка
				FTPСоединение.Получить(ФайлВходящегоСообщения.ПолноеИмя, ИмяВременногоФайлаАрхива);
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ПолучитьСообщениеОбОшибке(105);
				ДополнитьСообщениеОбОшибке(ТекстОшибки);
				Возврат Ложь;
			КонецПопытки;
			
			// распаковываем временный файл архива
			УспешноРаспакованно = ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяВременногоФайлаАрхива, ИмяКаталогаСообщенияОбмена(), ПарольАрхиваСообщенияОбмена);
			
			Если Не УспешноРаспакованно Тогда
				ПолучитьСообщениеОбОшибке(2);
				Возврат Ложь;
			КонецЕсли;
			
			// проверка на существование файла сообщения
			Файл = Новый Файл(ИмяФайлаСообщенияОбмена());
			
			Если Не Файл.Существует() Тогда
				
				ПолучитьСообщениеОбОшибке(5);
				Возврат Ложь;
				
			КонецЕсли;
			
		Иначе
			Попытка
				FTPСоединение.Получить(ФайлВходящегоСообщения.ПолноеИмя, ИмяФайлаСообщенияОбмена());
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ПолучитьСообщениеОбОшибке(105);
				ДополнитьСообщениеОбОшибке(ТекстОшибки);
				Возврат Ложь;
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПолучитьСообщениеОбОшибке(НомерСообщения)
	
	УстановитьСтрокуСообщенияОбОшибке(СообщенияОшибок[НомерСообщения]);
	
КонецПроцедуры

Процедура УстановитьСтрокуСообщенияОбОшибке(Знач Сообщение)
	
	Если Сообщение = Неопределено Тогда
		Сообщение = "Внутренняя ошибка";
	КонецЕсли;
	
	СтрокаСообщенияОбОшибке   = Сообщение;
	СтрокаСообщенияОбОшибкеЖР = ИмяОбъекта + ": " + Сообщение;
	
КонецПроцедуры

Процедура ДополнитьСообщениеОбОшибке(Сообщение)
	
	СтрокаСообщенияОбОшибкеЖР = СтрокаСообщенияОбОшибкеЖР + Символы.ПС + Сообщение;
	
КонецПроцедуры

// Переопределяемая функция, возвращает максимально допустимый размер
// сообщения, которое может быть отправлено.
// 
Функция МаксимальныйДопустимыйРазмерСообщения()
	
	Возврат FTPСоединениеМаксимальныйДопустимыйРазмерСообщения;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Функции-свойства

Функция СжиматьФайлИсходящегоСообщения()
	
	Возврат FTPСжиматьФайлИсходящегоСообщения;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Инициализация

Процедура ИнициализацияСообщений()
	
	СтрокаСообщенияОбОшибке   = "";
	СтрокаСообщенияОбОшибкеЖР = "";
	
КонецПроцедуры

Процедура ИнициализацияСообщенийОшибок()
	
	СообщенияОшибок = Новый Соответствие;
	
	// Общие коды ошибок
	СообщенияОшибок.Вставить(001, НСтр("ru = 'В каталоге обмена информацией не был обнаружен файл сообщения с данными.'"));
	СообщенияОшибок.Вставить(002, НСтр("ru = 'Ошибка при распаковке сжатого файла сообщения.'"));
	СообщенияОшибок.Вставить(003, НСтр("ru = 'Ошибка при сжатии файла сообщения обмена.'"));
	СообщенияОшибок.Вставить(004, НСтр("ru = 'Ошибка при создании временного каталога.'"));
	СообщенияОшибок.Вставить(005, НСтр("ru = 'Архив не содержит файл сообщения обмена.'"));
	
	// Коды ошибок, зависящие от вида транспорта
	СообщенияОшибок.Вставить(101, НСтр("ru = 'Не заданы обязательные параметры FTP-соединения (путь на сервере, порт, пользователь).'"));
	СообщенияОшибок.Вставить(102, НСтр("ru = 'Ошибка инициализации подключения к FTP-серверу.'"));
	СообщенияОшибок.Вставить(103, НСтр("ru = 'Ошибка подключения к FTP-серверу, проверьте правильность задания пути и права доступа к ресурсу.'"));
	СообщенияОшибок.Вставить(104, НСтр("ru = 'Ошибка при поиске файлов на FTP-сервере.'"));
	СообщенияОшибок.Вставить(105, НСтр("ru = 'Ошибка при получении файла с FTP-сервера.'"));
	СообщенияОшибок.Вставить(106, НСтр("ru = 'Ошибка удаления файла на FTP-сервере, проверьте права доступа к ресурсу.'"));
	
	СообщенияОшибок.Вставить(108, НСтр("ru = 'Превышен допустимый размер сообщения обмена.'"));
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Работа с FTP

Функция ПолучитьFTPСоединение()
	
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.ПолучитьНастройкиПроксиНаСервере1СПредприятие();
	
	Если НастройкаПроксиСервера <> Неопределено Тогда
		ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
		ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
		Если ИспользоватьПрокси Тогда
			Если ИспользоватьСистемныеНастройки Тогда
			// Системные настройки прокси-сервера
				Прокси = Новый ИнтернетПрокси(Истина);
			Иначе
			// Ручные настройки прокси-сервера
				Прокси = Новый ИнтернетПрокси;
				Прокси.Установить("ftp", НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"]);
				Прокси.Пользователь = НастройкаПроксиСервера["Пользователь"];
				Прокси.Пароль       = НастройкаПроксиСервера["Пароль"];
				Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
			КонецЕсли;
		Иначе
			// Не использовать прокси-сервер	
			Прокси = Новый ИнтернетПрокси(Ложь);
		КонецЕсли;
	Иначе
		Прокси = Неопределено;
	КонецЕсли;
	
	FTPСоединение = Новый FTPСоединение(ИмяFTPСервера,
										FTPСоединениеПорт,
										FTPСоединениеПользователь,
										FTPСоединениеПароль,
										Прокси,
										FTPСоединениеПассивноеСоединение);
	
	Возврат FTPСоединение;
	
КонецФункции

Функция ВыполнитьКопированиеФайлаНаFTPСервер(Знач ИмяФайлаИсточника, ИмяФайлаПриемника)
	
	Перем КаталогНаСервере;
	
	СерверИКаталогНаСервере = РазделитьFTPРесурсНаСерверИКаталог(СокрЛП(FTPСоединениеПуть));
	КаталогНаСервере = СерверИКаталогНаСервере.ИмяКаталога;
	
	Попытка
		FTPСоединение = ПолучитьFTPСоединение();
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		FTPСоединение.Записать(ИмяФайлаИсточника, КаталогНаСервере + ИмяФайлаПриемника);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(103);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		МассивФайлов = FTPСоединение.НайтиФайлы(КаталогНаСервере, ИмяФайлаПриемника, Ложь);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(104);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат МассивФайлов.Количество() > 0;
	
КонецФункции

Функция ВыполнитьУдалениеФайлаНаFTPСервере(Знач ИмяФайла, ПроверкаПодключения = Ложь)
	
	Перем КаталогНаСервере;
	
	СерверИКаталогНаСервере = РазделитьFTPРесурсНаСерверИКаталог(СокрЛП(FTPСоединениеПуть));
	КаталогНаСервере = СерверИКаталогНаСервере.ИмяКаталога;
	
	Попытка
		FTPСоединение = ПолучитьFTPСоединение();
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		FTPСоединение.Удалить(КаталогНаСервере + ИмяФайла);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(106);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		
		Если ПроверкаПодключения Тогда
			
			СообщениеОбОшибке = НСтр("ru = 'Не удалось проверить подключение с помощью тестового файла ""%1"".
			|Возможно, заданный каталог не существует или не доступен.
			|Рекомендуется также обратиться к документации по FTP-серверу для настройки поддержки имен файлов с кириллицей.'");
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ОбменДаннымиСервер.ИмяФайлаПроверкиПодключения());
			ДополнитьСообщениеОбОшибке(СообщениеОбОшибке);
			
		КонецЕсли;
		
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция РазделитьFTPРесурсНаСерверИКаталог(знач ПолныйПуть)
	
	Результат = Новый Структура("ИмяСервера,ИмяКаталога", "", "");
	
	Если ВРег(Лев(ПолныйПуть, 6)) = "FTP://" Тогда
		ПолныйПуть = Прав(ПолныйПуть, СтрДлина(ПолныйПуть) - 6);
	КонецЕсли;
	
	Позиция = Найти(ПолныйПуть, "/");
	
	Если Позиция = 0 Тогда
		Результат.ИмяСервера = ПолныйПуть;
		Результат.ИмяКаталога = "/";
		Возврат Результат;
	КонецЕсли;
	
	Результат.ИмяСервера = Лев(ПолныйПуть, Позиция - 1);
	Результат.ИмяКаталога = Прав(ПолныйПуть, СтрДлина(ПолныйПуть) - Позиция);
	
	Если Прав(Результат.ИмяКаталога, 1) <> "/" Тогда
		Результат.ИмяКаталога = Результат.ИмяКаталога + "/";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Операторы основной программы

ИнициализацияСообщений();
ИнициализацияСообщенийОшибок();

ВременныйКаталогСообщенийОбмена = Неопределено;
ВременныйФайлСообщенияОбмена    = Неопределено;

ИмяFTPСервера       = Неопределено;
КаталогНаFTPСервере = Неопределено;

ИмяОбъекта = НСтр("ru = 'Обработка: %1'");
ИмяОбъекта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ИмяОбъекта, Метаданные().Имя);
