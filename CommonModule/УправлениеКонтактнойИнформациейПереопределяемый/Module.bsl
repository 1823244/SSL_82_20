﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура обновления ИБ для справочника видов контактной информации.
//
// Инструкция:
// Для каждого объекта, владельца КИ, для каждого соответствующего ему вида КИ добавить 
// строчку вида: УправлениеКонтактнойИнформацией.ОбновитьВидКИ(.....). При этом,
// важен порядок в котором будут осуществляться эти вызовы, чем раньше вызов для вида КИ,
// тем выше этот вид КИ будет располагаться на форме объекта.
//
// Параметры функции УправлениеКонтактнойИнформацией.ОбновитьВидКИ:
// 1. Вид КИ - Ссылка на предопределенный вид КИ.
// 2. Тип КИ - Ссылка на перечисление
// 3. МожноИзменятьСпособРедактирования  - Определяет, можно ли в режиме Предприятие изменить способ редактирования,
//                                         например, для адресов, которые попадают в регл. отчетность, нужно
//                                         запретить возможность изменения.
// 4. РедактированиеТолькоВДиалоге       - Если установить Истина, то будет значение вида КИ можно будет
//                                         редактировать только в форме ввода (имеет смысл только для
//                                         адресов, телефонов и факсов).
// 5. АдресТолькоРоссийский              - Если установить Истина, то для адресов можно будет ввести 
//                                         только российский адрес (имеет смысл только для адресов).
// 6. Порядок                            - Определяет порядок элемента, для сортировки относительно других
//
//
Процедура КонтактнаяИнформацияОбновлениеИБ() Экспорт
	
	// СтандартныеПодсистемы 
	
	// Справочник "Пользователи"
	УправлениеКонтактнойИнформацией.ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.EmailПользователя,        		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты, Истина, Ложь, Ложь, 1);
	
	// СтандартныеПодсистемы.Организации
	
	// Справочник "Организации"
	УправлениеКонтактнойИнформацией.ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,            Перечисления.ТипыКонтактнойИнформации.Адрес,                 Истина, Ложь, Истина, 1);
	УправлениеКонтактнойИнформацией.ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации,          Перечисления.ТипыКонтактнойИнформации.Адрес,                 Истина, Ложь,   Ложь, 2);
	УправлениеКонтактнойИнформацией.ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации,            Перечисления.ТипыКонтактнойИнформации.Телефон,               Истина, Ложь,   Ложь, 3);
	УправлениеКонтактнойИнформацией.ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ФаксОрганизации,               Перечисления.ТипыКонтактнойИнформации.Факс,                  Истина, Ложь,   Ложь, 4);
	УправлениеКонтактнойИнформацией.ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.EmailОрганизации,              Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты, Истина, Ложь,   Ложь, 5);
	УправлениеКонтактнойИнформацией.ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации,      Перечисления.ТипыКонтактнойИнформации.Адрес,                 Истина, Ложь,   Ложь, 6);
	УправлениеКонтактнойИнформацией.ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияОрганизации,   Перечисления.ТипыКонтактнойИнформации.Другое,                Истина, Ложь,   Ложь, 7);
	// Конец СтандартныеПодсистемы.Организации
	
	// Конец СтандартныеПодсистемы 
	
	
	
КонецПроцедуры

