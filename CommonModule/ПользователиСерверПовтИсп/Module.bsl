﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает таблицу значений имен всех ролей конфигурации.
//
// Параметры:
// 
// Возвращаемое значение:
//  ТаблицаЗначений с колонками:
//    Имя - Строка.
//
Функция ВсеРоли() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		Таблица.Добавить().Имя = Роль.Имя;
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

// Возвращает таблицу значений с колонками Роль и РольСиноним,
// которая формируется из метаданных.
//
// Возвращаемое значение:
//  ТаблицаЗначений с колонками:
//    Роль        - Строка(150),
//    СинонимРоли - Строка(1000).
//
Функция СинонимыРолей() Экспорт
	
	СинонимыРолей = Новый ТаблицаЗначений;
	СинонимыРолей.Колонки.Добавить("Роль",        Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(150)));
	СинонимыРолей.Колонки.Добавить("РольСиноним", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(1000)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		
		ОписаниеРоли = СинонимыРолей.Добавить();
		ОписаниеРоли.Роль        = Роль.Имя;
		ОписаниеРоли.РольСиноним = Роль.Синоним;
		
	КонецЦикла;
		
	Возврат СинонимыРолей;
	
КонецФункции

// Возвращает дерево ролей с подсистемами или без них.
//  Если роль не принадлежит ни одной подсистеме она добавляется "в корень".
// 
// Параметры:
//  ПоПодсистемам - Булево, если Ложь, все роли добавляются в "корень".
// 
// Возвращаемое значение:
//  ДеревоЗначений с колонками:
//    ЭтоРоль - Булево
//    Имя     - Строка - имя     роли или подсистемы
//    Синоним - Строка - синоним роли или подсистемы
//
Функция ДеревоРолей(ПоПодсистемам = Истина, Знач ТипПользователя = Неопределено) Экспорт
	
	Если ТипПользователя = Неопределено Тогда
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			ТипПользователя = Перечисления.ТипыПользователей.ПользовательОбластиДанных;
		Иначе
			ТипПользователя = Перечисления.ТипыПользователей.ПользовательЛокальногоРешения;
		КонецЕсли;
	КонецЕсли;
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("ЭтоРоль", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Имя",     Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	
	Если ПоПодсистемам Тогда
		ЗаполнитьПодсистемыИРоли(Дерево.Строки, , ТипПользователя);
	КонецЕсли;
	
	НедоступныеРоли = ПользователиСерверПовтИсп.НедоступныеРолиПоТипуПользователя(ТипПользователя);
	
	// Добавление ненайденных ролей
	Для каждого Роль Из Метаданные.Роли Цикл
		
		Если НедоступныеРоли.Получить(Роль) <> Неопределено
			ИЛИ ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
			
			Продолжить;
		КонецЕсли;
		
		Если Дерево.Строки.НайтиСтроки(Новый Структура("ЭтоРоль, Имя", Истина, Роль.Имя), Истина).Количество() = 0 Тогда
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.ЭтоРоль       = Истина;
			СтрокаДерева.Имя           = Роль.Имя;
			СтрокаДерева.Синоним       = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Дерево.Строки.Сортировать("ЭтоРоль Убыв, Синоним Возр", Истина);
	
	Возврат Дерево;
	
КонецФункции

Функция НедоступныеПраваПоТипуПользователя(Знач ТипПользователя) Экспорт
	
	Если ТипПользователя = Перечисления.ТипыПользователей.ВнешнийПользователь Тогда
		Результат = Новый Массив;
		Результат.Добавить("Администрирование");
		Результат.Добавить("АдминистрированиеДанных");
	ИначеЕсли ТипПользователя = Перечисления.ТипыПользователей.ПользовательЛокальногоРешения Тогда
		Результат = Новый Массив;
	ИначеЕсли ТипПользователя = Перечисления.ТипыПользователей.ПользовательОбластиДанных Тогда
		Результат = Новый Массив;
		Результат.Добавить("Администрирование");
		Результат.Добавить("ОбновлениеКонфигурацииБазыДанных");
		Результат.Добавить("МонопольныйРежим");
		Результат.Добавить("ТолстыйКлиент");
		Результат.Добавить("ВнешнееСоединение");
		Результат.Добавить("Automation");
		Результат.Добавить("ИнтерактивноеОткрытиеВнешнихОбработок");
		Результат.Добавить("ИнтерактивноеОткрытиеВнешнихОтчетов");
		Результат.Добавить("РежимВсеФункции");
	Иначе
		ШаблонСсобщения = НСтр("ru = 'Неизвестный тип пользователя %1'");
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСсобщения, ТипПользователя);
		ВызватьИсключение(Сообщение);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция РазрешеноИзменениеОбщихДанных(Знач ТипПользователя) Экспорт
	
	Если ТипПользователя = Перечисления.ТипыПользователей.ВнешнийПользователь Тогда
		Возврат Истина;
	ИначеЕсли ТипПользователя = Перечисления.ТипыПользователей.ПользовательЛокальногоРешения Тогда
		Возврат Истина;
	ИначеЕсли ТипПользователя = Перечисления.ТипыПользователей.ПользовательОбластиДанных Тогда
		Возврат Ложь;
	Иначе
		ШаблонСсобщения = НСтр("ru = 'Неизвестный тип пользователя %1'");
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСсобщения, ТипПользователя);
		ВызватьИсключение(Сообщение);
	КонецЕсли;
	
КонецФункции

Функция ДоступноИзменениеОбщихДанных(Знач ИмяРоли) Экспорт
	
	Возврат ПользователиСерверПовтИсп.ОбщиеДанныеДоступныеДляИзменения(ИмяРоли).Количество() > 0;
	
КонецФункции

// Возвращает таблицу полных имен неразделенных объектов метаданных и
// соответствующих им наборов прав доступа.
//
// Параметры:
// ИмяРоли - Строка.
//
// Возвращаемое значение:
// ТаблицаЗначений с колонками: 
//  Имя   - Строка - Полное имя объекта метаданных.
//  Право - Строка - Имя права доступа.
//
Функция ОбщиеДанныеДоступныеДляИзменения(Знач ИмяРоли) Экспорт
	
	Роль = Метаданные.Роли[ИмяРоли];
	
	ВидыМетаданных = Новый Массив;
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыОбмена, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Константы, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Справочники, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Последовательности, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Документы, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыВидовХарактеристик, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыСчетов, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыВидовРасчета, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.БизнесПроцессы, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Задачи, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыСведений, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыНакопления, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыБухгалтерии, Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыРасчета, Ложь));
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаОбъектов = Новый ТаблицаЗначений;
	ТаблицаОбъектов.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	ТаблицаОбъектов.Колонки.Добавить("Право", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	
	ПроверяемыеПрава = Новый Массив;
	ПроверяемыеПрава.Добавить(Новый Структура("Имя, Ссылочное", "Изменение", Ложь));
	ПроверяемыеПрава.Добавить(Новый Структура("Имя, Ссылочное", "Добавление", Истина));
	ПроверяемыеПрава.Добавить(Новый Структура("Имя, Ссылочное", "Удаление", Истина));
	
	РазделенныеОбъектыМетаданных = ОбщегоНазначенияПовтИсп.РазделенныеОбъектыМетаданных();
	
	Для Каждого ОписаниеВида Из ВидыМетаданных Цикл // По видам метаданных
		Для Каждого ОбъектМетаданных Из ОписаниеВида.Вид Цикл // По объектам вида
			ПолноеИмяОбъектаМетаданных = ОбъектМетаданных.ПолноеИмя();
			Если РазделенныеОбъектыМетаданных.Получить(ПолноеИмяОбъектаМетаданных) = Неопределено Тогда
				
				Для каждого ОписаниеПрава Из ПроверяемыеПрава Цикл
					Если НЕ ОписаниеПрава.Ссылочное
						ИЛИ ОписаниеВида.Ссылочный Тогда
						
						Если ПравоДоступа(ОписаниеПрава.Имя, ОбъектМетаданных, Роль) Тогда
							СтрокаПрава = ТаблицаОбъектов.Добавить();
							СтрокаПрава.Имя = ПолноеИмяОбъектаМетаданных;
							СтрокаПрава.Право = ОписаниеПрава.Имя;
						КонецЕсли;
						
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаОбъектов;
	
КонецФункции

Функция НедоступныеРолиПоТипуПользователя(Знач ТипПользователя) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Соответствие;
	
	НедоступныеПрава = НедоступныеПраваПоТипуПользователя(ТипПользователя);
		
	ПроверятьОбщиеДанные = НЕ РазрешеноИзменениеОбщихДанных(ТипПользователя);
		
	Для каждого Роль Из Метаданные.Роли Цикл
		НайденыНедоступныеПрава = Ложь;
		Для каждого Право Из НедоступныеПрава Цикл
			Если ПравоДоступа(Право, Метаданные, Роль) Тогда
				НайденыНедоступныеПрава = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ПроверятьОбщиеДанные
			И НЕ НайденыНедоступныеПрава Тогда
			
			НайденыНедоступныеПрава = ДоступноИзменениеОбщихДанных(Роль.Имя);
		КонецЕсли;
		
		Если НайденыНедоступныеПрава Тогда
			Результат.Вставить(Роль, Истина);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

Функция АутентификацияOpenIDНастраивается() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Попытка
		АутентификацияOpenID = ПользователиИнформационнойБазы.ТекущийПользователь().АутентификацияOpenID;
		ИтогПроверки = Истина;
	Исключение
		ИтогПроверки = Ложь;
	КонецПопытки;
	
	Возврат ИтогПроверки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Процедура ЗаполнитьПодсистемыИРоли(КоллекцияСтрокДерева, Подсистемы = Неопределено, ТипПользователя)
	
	НедоступныеРоли = 
		ПользователиСерверПовтИсп.НедоступныеРолиПоТипуПользователя(ТипПользователя);
	
	Если Подсистемы = Неопределено Тогда
		Подсистемы = Метаданные.Подсистемы;
	КонецЕсли;
	
	Для каждого Подсистема Из Подсистемы Цикл
		
		ОписаниеПодсистемы = КоллекцияСтрокДерева.Добавить();
		ОписаниеПодсистемы.Имя           = Подсистема.Имя;
		ОписаниеПодсистемы.Синоним       = ?(ЗначениеЗаполнено(Подсистема.Синоним), Подсистема.Синоним, Подсистема.Имя);
		
		ЗаполнитьПодсистемыИРоли(ОписаниеПодсистемы.Строки, Подсистема.Подсистемы, ТипПользователя);
		
		Для каждого Роль Из Метаданные.Роли Цикл
			Если НедоступныеРоли.Получить(Роль) <> Неопределено
				ИЛИ ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
				
				Продолжить;
			КонецЕсли;
			
			Если Подсистема.Состав.Содержит(Роль) Тогда
				ОписаниеРоли = ОписаниеПодсистемы.Строки.Добавить();
				ОписаниеРоли.ЭтоРоль       = Истина;
				ОписаниеРоли.Имя           = Роль.Имя;
				ОписаниеРоли.Синоним       = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
			КонецЕсли;
		КонецЦикла;
		
		Если ОписаниеПодсистемы.Строки.НайтиСтроки(Новый Структура("ЭтоРоль", Истина), Истина).Количество() = 0 Тогда
			КоллекцияСтрокДерева.Удалить(ОписаниеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

