﻿///////////////////////////////////////////////////////////////////////////////////
// СообщенияУдаленногоАдминистрированияПовтИсп.
//
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возврвщает тип, являющийся базовым для всех типов сообщений
// удаленного администрирования
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - базовый тип сообщений удаленного администрирования
//
Функция АбстрактноеСообщение() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетСообщенияУдаленногоАдминистрирования(), "Сообщение");
	
КонецФункции

// Возвращает типы объектов XDTO содержащихся в заданном
// пакете, являющиеся типа сообщений удаленного администрирования
//
// Параметры:
//  URIПакета - Строка - URI пакета XDTO, типы сообщений из которого
//   требуется получить
//
// Возвращаемое значение:
//  ФиксированныйМассив(ТипОбъектаXDTO) - типы сообщений найденные в пакете
//
Функция ПолучитьТипыСообщенийПакета(Знач URIПакета) Экспорт
	
	Результат = Новый Массив;
	
	МоделиПакетов = ФабрикаXDTO.ЭкспортМоделиXDTO(URIПакета);
	
	БазовыйТип = АбстрактноеСообщение();
	
	Для каждого МодельПакета Из МоделиПакетов.package Цикл
		Для каждого МодельОбъектногоТипа из МодельПакета.objectType Цикл
			ТипОбъекта = ФабрикаXDTO.Тип(URIПакета, МодельОбъектногоТипа.name);
			Если НЕ ТипОбъекта.Абстрактный
				И БазовыйТип.ЭтоПотомок(ТипОбъекта) Тогда
				
				Результат.Добавить(ТипОбъекта);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Возвращает имена каналов сообщений из заданного пакета
//
// Параметры:
//  URIПакета - Строка - URI пакета XDTO, типы сообщений из которого
//   требуется получить
//
// Возвращаемое значение:
//  ФиксированныйМассив(Строка) - имена каналов найденные в пакете
//
Функция ПолучитьКаналыПакета(Знач URIПакета) Экспорт
	
	Результат = Новый Массив;
	
	ТипыСообщенийПакета = 
		СообщенияУдаленногоАдминистрированияПовтИсп.ПолучитьТипыСообщенийПакета(URIПакета);
	
	Для каждого ТипСообщения Из ТипыСообщенийПакета Цикл
		Результат.Добавить(СообщенияУдаленногоАдминистрирования.ИмяКаналаПоТипуСообщения(ТипСообщения));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////////
// Функции, возвращающие типы сообщений и имена содержащих их пакетов

// Возвращает имя пакета удаленного администрирования.
//
// Возвращаемое значение:
// Строка.
//
Функция ПакетУдаленноеАдминистрирование() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/RemoteAdministration/App";
	
КонецФункции

// Возвращает имя пакета контроля удаленного администрирования.
//
// Возвращаемое значение:
// Строка.
//
Функция ПакетКонтрольУдаленногоАдминистрирования() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/RemoteAdministration/Control";
	
КонецФункции

// Возвращает имя пакета сообщения удаленного администрирования.
//
// Возвращаемое значение:
// Строка.
//
Функция ПакетСообщенияУдаленногоАдминистрирования() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/RemoteAdministration/Messages";
	
КонецФункции

// Возвращает тип сообщения ОбновитьПользователя.
//
// Возвращаемое значение:
// XDTO-пакеты.УдаленноеАдминистрированиеВМоделиСервиса.ОбновитьПользователя 
//
Функция СообщениеОбновитьПользователя() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУдаленноеАдминистрирование(), "ОбновитьПользователя");
	
КонецФункции

// Возвращает тип сообщения УстановитьПолныеПраваОбластиДанных.
//
// Возвращаемое значение:
// XDTO-пакеты.УдаленноеАдминистрированиеВМоделиСервиса.УстановитьПолныеПраваОбластиДанных 
//
Функция СообщениеУстановитьПолныеПраваОбластиДанных() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУдаленноеАдминистрирование(), "УстановитьПолныеПраваОбластиДанных");
	
КонецФункции

// Возвращает тип сообщения УстановитьДоступКОбластиДанных.
//
// Возвращаемое значение:
// XDTO-пакеты.УдаленноеАдминистрированиеВМоделиСервиса.УстановитьДоступКОбластиДанных 
//
Функция СообщениеУстановитьДоступКОбластиДанных() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУдаленноеАдминистрирование(), "УстановитьДоступКОбластиДанных");
	
КонецФункции

// Возвращает тип сообщения УстановитьПраваПользователяПоУмолчанию.
//
// Возвращаемое значение:
// XDTO-пакеты.УдаленноеАдминистрированиеВМоделиСервиса.УстановитьПраваПользователяПоУмолчанию 
//
Функция СообщениеУстановитьПраваПользователяПоУмолчанию() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУдаленноеАдминистрирование(), "УстановитьПраваПользователяПоУмолчанию");
	
КонецФункции

// Возвращает тип сообщения ПодготовитьОбластьДанных.
//
// Возвращаемое значение:
// XDTO-пакеты.УдаленноеАдминистрированиеВМоделиСервиса.ПодготовитьОбластьДанных 
//
Функция СообщениеПодготовитьОбластьДанных() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУдаленноеАдминистрирование(), "ПодготовитьОбластьДанных");
	
КонецФункции

// Возвращает тип сообщения УдалитьОбластьДанных.
//
// Возвращаемое значение:
// XDTO-пакеты.УдаленноеАдминистрированиеВМоделиСервиса.УдалитьОбластьДанных 
//
Функция СообщениеУдалитьОбластьДанных() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУдаленноеАдминистрирование(), "УдалитьОбластьДанных");
	
КонецФункции

// Возвращает тип сообщения УстановитьПараметрыОбластиДанных.
//
// Возвращаемое значение:
// XDTO-пакеты.УдаленноеАдминистрированиеВМоделиСервиса.УстановитьПараметрыОбластиДанных 
//
Функция СообщениеУстановитьПараметрыОбластиДанных() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУдаленноеАдминистрирование(), "УстановитьПараметрыОбластиДанных");
	
КонецФункции

// Возвращает тип сообщения ОбластьДанныхПодготовлена.
//
// Возвращаемое значение:
// XDTO-пакеты.КонтрольУдаленногоАдминистрирования.ОбластьДанныхПодготовлена
//
Функция СообщениеОбластьДанныхПодготовлена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетКонтрольУдаленногоАдминистрирования(), "ОбластьДанныхПодготовлена");
	
КонецФункции

// Возвращает тип сообщения ОбластьДанныхУдалена.
//
// Возвращаемое значение:
// XDTO-пакеты.КонтрольУдаленногоАдминистрирования.ОбластьДанныхУдалена
//
Функция СообщениеОбластьДанныхУдалена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетКонтрольУдаленногоАдминистрирования(), "ОбластьДанныхУдалена");
	
КонецФункции

// Возвращает тип сообщения ОшибкаПодготовкиОбластиДанных.ОшибкаПодготовкиОбластиДанных
//
// Возвращаемое значение:
// XDTO-пакеты.КонтрольУдаленногоАдминистрирования.
//
Функция СообщениеОшибкаПодготовкиОбластиДанных() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетКонтрольУдаленногоАдминистрирования(), "ОшибкаПодготовкиОбластиДанных");
	
КонецФункции

// Возвращает тип сообщения ОшибкаУдаленияОбластиДанных.
//
// Возвращаемое значение:
// XDTO-пакеты.КонтрольУдаленногоАдминистрирования.ОшибкаУдаленияОбластиДанных
//
Функция СообщениеОшибкаУдаленияОбластиДанных() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетКонтрольУдаленногоАдминистрирования(), "ОшибкаУдаленияОбластиДанных");
	
КонецФункции

// Возвращает тип сообщения УстановитьПараметрыИБ.
//
// Возвращаемое значение:
// XDTO-пакеты.УдаленноеАдминистрированиеВМоделиСервиса.УстановитьПараметрыИБ
//
Функция СообщениеУстановитьПараметрыИБ() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУдаленноеАдминистрирование(), "УстановитьПараметрыИБ");
	
КонецФункции

// Возвращает тип сообщения УстановитьКонечнуюТочкуМенеджераСервиса.
//
// Возвращаемое значение:
// XDTO-пакеты.УдаленноеАдминистрированиеВМоделиСервиса.УстановитьКонечнуюТочкуМенеджераСервиса 
//
Функция СообщениеУстановитьКонечнуюТочкуМенеджераСервиса() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУдаленноеАдминистрирование(), "УстановитьКонечнуюТочкуМенеджераСервиса");
	
КонецФункции
