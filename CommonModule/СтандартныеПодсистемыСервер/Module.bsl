﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Неинтерактивное обновление данных ИБ при смене версии библиотеки
// Обязательная "точка входа" обновления ИБ в библиотеке.
//
Процедура ВыполнитьОбновлениеИнформационнойБазы() Экспорт
	
	ОбновлениеИнформационнойБазы.ВыполнитьИтерациюОбновления("СтандартныеПодсистемы", 
		ВерсияБиблиотеки(), СтандартныеПодсистемыПереопределяемый.ОбработчикиОбновленияСтандартныхПодсистем());
	
КонецПроцедуры

// Возвращает номер версии Библиотеки стандартных подсистем.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат "2.0.1.19";
	
КонецФункции

// Заполняет структуру параметров, необходимых для работы клиентского кода
// данной подсистемы при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
// Возвращаемое значение:
//   Булево   - Ложь, если дальнейшее заполнение параметров необходимо прервать.
//
Функция ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Параметры.Вставить("ОшибкаАвторизации", Пользователи.АвторизоватьТекущегоПользователя());
	Если ЗначениеЗаполнено(Параметры.ОшибкаАвторизации) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Заполняет структуру параметров, необходимых для работы клиентского кода
// данной подсистемы. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ДобавитьПараметрыРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("ИнформационнаяБазаЗаблокированаДляОбновления", 
		ОбновлениеИнформационнойБазы.ПроверитьНевозможностьОбновленияИнформационнойБазы());
	Параметры.Вставить("НеобходимоОбновлениеИнформационнойБазы", 
		ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы());
	Параметры.Вставить("АвторизованныйПользователь", Пользователи.АвторизованныйПользователь());
	Параметры.Вставить("ЭтоБазоваяВерсияКонфигурации", СтандартныеПодсистемыПереопределяемый.ЭтоБазоваяВерсияКонфигурации());
	
	УстановитьПривилегированныйРежим(Истина);
	Параметры.Вставить("ЗаголовокПриложения", СокрЛП(Константы.ЗаголовокСистемы.Получить()));
	УстановитьПривилегированныйРежим(Ложь);
	Параметры.Вставить("ИмяКонфигурации", Метаданные.Имя);
	Параметры.Вставить("СинонимКонфигурации", Метаданные.Синоним);
	Параметры.Вставить("ВерсияКонфигурации", Метаданные.Версия);
	Параметры.Вставить("ПодробнаяИнформация", Метаданные.ПодробнаяИнформация);
	Параметры.Вставить("ИнформационнаяБазаФайловая", ОбщегоНазначения.ИнформационнаяБазаФайловая());
	Параметры.Вставить("ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", ЗапрашиватьПодтверждениеПриЗавершенииПрограммы());
	Параметры.Вставить("ТекущийПользователь", Пользователи.ТекущийПользователь());
	// Параметры для внешних подключений пользователей
	Параметры.Вставить("ИнформацияОПользователе", ПолучитьИнформациюОПользователе());
	Параметры.Вставить("ИмяCOMСоединителя", ОбщегоНазначения.ИмяCOMСоединителя());
	
	Параметры.Вставить("ПоправкаКВремениСеанса", ТекущаяДатаСеанса()); // записываем серверное время для последующей замены его на разницу с клиентом.
	СтандартныеПодсистемыПереопределяемый.ДобавитьПараметрыРаботыКлиентаВМоделиСервиса(Параметры);
	
КонецПроцедуры

// Возвращает массив поддерживаемых подсистемой ИмяПодсистемы названий номеров версий.
//
// Параметры:
// ИмяПодсистемы - Строка - Имя подсистемы.
//
// Возвращаемое значение:
// Массив строк.
//
Функция ПоддерживаемыеВерсии(ИмяПодсистемы) Экспорт
	
	МассивВерсий = Неопределено;
	
	СтруктураПоддерживаемыхВерсий = Новый Структура;
	СтандартныеПодсистемыПереопределяемый.ПолучитьПоддерживаемыеВерсии(СтруктураПоддерживаемыхВерсий);
	
	СтруктураПоддерживаемыхВерсий.Свойство(ИмяПодсистемы, МассивВерсий);
	
	Если МассивВерсий = Неопределено Тогда
		Возврат ОбщегоНазначения.ЗначениеВСтрокуXML(Новый Массив);
	Иначе
		Возврат ОбщегоНазначения.ЗначениеВСтрокуXML(МассивВерсий);
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализации параметров сеанса
//

// Инициализация параметров сеанса.
// Параметры
//  ИменаПараметровСеанса - массив, неопределено - 
//                         в массиве имена параметров сеанса для инициализации
//
//  Возвращает массив имен установленных параметров сеанса
//
Функция УстановкаПараметровСеанса(ИменаПараметровСеанса) Экспорт
	
	Перем ТекстСообщения;
	
	// Параметры сеанса, инициализация которых требует обращения к одним и тем же данным
	// следует инициализировать сразу группой. Для того, чтобы избежать их повторной инициализации,
	// имена уже установленных параметров сеанса сохраняются в массиве УстановленныеПараметры
	УстановленныеПараметры = Новый Массив;
	
	Если ИменаПараметровСеанса = Неопределено Тогда
		Возврат УстановленныеПараметры;
	КонецЕсли;
	
	Обработчики = СтандартныеПодсистемыПереопределяемый.ОбработчикиИнициализацииПараметровСеансаСтандартныхПодсистем();
	ОбработчикиСобственные = ОбщегоНазначенияПереопределяемый.ОбработчикиИнициализацииПараметровСеанса();
	
	Для Каждого Запись Из ОбработчикиСобственные Цикл
		Обработчики.Вставить(Запись.Ключ, Запись.Значение);
	КонецЦикла;
	
	// массив с ключами параметров сеанса
	// задаются начальным словом в имени параметра сеанса и символом "*"
	ПараметрыСеансаКлючи = Новый Массив;
	
	Для Каждого Запись Из Обработчики Цикл
		Если Найти(Запись.Ключ, "*") > 0 Тогда
			КлючПараметра = СокрЛП(Запись.Ключ);
			ПараметрыСеансаКлючи.Добавить(Лев(КлючПараметра, СтрДлина(КлючПараметра)-1));
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ИмяПараметра Из ИменаПараметровСеанса Цикл
		Если УстановленныеПараметры.Найти(ИмяПараметра) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Обработчик = Обработчики.Получить(ИмяПараметра);
		Если Обработчик <> Неопределено Тогда
			Если Не ОбщегоНазначения.ПроверитьИмяЭкспортнойПроцедуры(Обработчик, ТекстСообщения) Тогда
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
			
			Выполнить Обработчик + "(ИмяПараметра, УстановленныеПараметры)";
			Продолжить;
		КонецЕсли;
		Для Каждого ИмяКлючаПараметра Из ПараметрыСеансаКлючи Цикл
			Если Лев(ИмяПараметра, СтрДлина(ИмяКлючаПараметра)) = ИмяКлючаПараметра Тогда
				Обработчик = Обработчики.Получить(ИмяКлючаПараметра+"*");
				Если Не ОбщегоНазначения.ПроверитьИмяЭкспортнойПроцедуры(Обработчик, ТекстСообщения) Тогда
					ВызватьИсключение ТекстСообщения;
				КонецЕсли;
				Выполнить Обработчик + "(ИмяПараметра, УстановленныеПараметры)";
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат УстановленныеПараметры;
	
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
	Обработчик.Версия = "1.1.3.9";
	Обработчик.Процедура = "СтандартныеПодсистемыСервер.УстановитьКонстантуНеИспользоватьРазделениеПоОбластямДанных";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.Процедура = "Справочники.ИдентификаторыОбъектовМетаданных.ОбновитьДанныеСправочника";
	Обработчик.Приоритет = 999;
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.Процедура = "СтандартныеПодсистемыСервер.ПометитьЗаписиКэшаВерсийНеактуальными";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

// Устанавливает корректное значеение константе НеИспользоватьРазделениеПоОбластямДанных
//
Процедура УстановитьКонстантуНеИспользоватьРазделениеПоОбластямДанных() Экспорт
	
	Константы.НеИспользоватьРазделениеПоОбластямДанных.Установить(НЕ Константы.ИспользоватьРазделениеПоОбластямДанных.Получить());
	
КонецПроцедуры

// Сбрасывает дату обновления всех записей кэша версий, таким
// образом все записи кэша начинают считаться неактуальными.
//
Процедура ПометитьЗаписиКэшаВерсийНеактуальными() Экспорт
	
	НачатьТранзакцию();
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("РегистрСведений.КэшПрограммныхИнтерфейсов");
	Блокировка.Заблокировать();
	
	НаборЗаписей = РегистрыСведений.КэшПрограммныхИнтерфейсов.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	Для каждого Запись Из НаборЗаписей Цикл
		Запись.ДатаОбновления = Неопределено;
	КонецЦикла;
	НаборЗаписей.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Функция ПолучитьИнформациюОПользователе()
	
	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	Если ПользователиСерверПовтИсп.АутентификацияOpenIDНастраивается() Тогда
		АутентификацияOpenID = ТекущийПользователь.АутентификацияOpenID;
	Иначе
		АутентификацияOpenID = Истина;
	КонецЕсли;
	
	Информация = Новый Структура;
	Информация.Вставить("Имя",                       ТекущийПользователь.Имя);
	Информация.Вставить("ПолноеИмя",                 ТекущийПользователь.ПолноеИмя);
	Информация.Вставить("ПарольУстановлен",          ТекущийПользователь.ПарольУстановлен);
	Информация.Вставить("АутентификацияOpenID",      АутентификацияOpenID);
	Информация.Вставить("АутентификацияСтандартная", ТекущийПользователь.АутентификацияСтандартная);
	Информация.Вставить("АутентификацияОС",          ТекущийПользователь.АутентификацияОС);
	
	Возврат Информация;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Подтверждение завершения работы программы

// Прочитать настройку подтверждения завершения работы программы
// для текущего пользователя.
// 
// Возвращаемое значение:
//   Булево   - значение настройки.
// 
Функция ЗапрашиватьПодтверждениеПриЗавершенииПрограммы() Экспорт
	
	Результат = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы");
	Если Результат = Неопределено Тогда
		Результат = Истина;
		СтандартныеПодсистемыВызовСервера.СохранитьНастройкуПодтвержденияПриЗавершенииПрограммы(Результат);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции
