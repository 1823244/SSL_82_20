﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает список имен объектов метаданных, данные которых могут содержать ссылки на различные объекты метаданных,
// но при этом эти ссылки не должны учитываться в бизнес-логике приложения.
//
// Пример:
// Для документ "Реализация товаров и услуг" настроена подсистема версионирования объектов,
// и подсистема свойств. При этом на экземпляр документа может быть множество ссылок 
// в информационной базе (из других документов, регистров). Часть ссылок имеют значение для бизнес-логики
// (например движения по регистрам). Другая часть ссылок - "техногенные" ссылки на объект из объектов ИБ,
// которые относятся к подсистеме версионирования объектов и подсистеме свойств. Такие "техногенные"
// ссылки должны быть отфильтрованы, например, в обработке удаления помеченных и при поиске ссылок на объект
// в подсистеме запрета редактирования ключевых реквизитов.
// Список таких "техногенных" объектов нужно перечислить в этой функции.
//
// Возвращаемое значение:
//  Массив       - массив строк, например, "РегистрСведений.ВерсииОбъектов".
//
Функция ПолучитьИсключенияПоискаСсылок() Экспорт
	
	Массив = Новый Массив;
	
	Возврат Массив;
	
КонецФункции 

// Обработчик события, возникающего при обновлении
// данных справочника ИдентификаторыОбъектовМетаданных
//
// Параметры:
//  ВидСобытия   - Строка - "Добавление", "Изменение", "Удаление"
//  Свойства     - Структура:
//                   Старые     - Структура - основные поля и значения старого элемента справочника
//                   Новые      - Структура - основные поля и значения нового  элемента справочника
//                   СтандартнаяЗаменаСсылок
//                              - Булево - если свойство задано Истина,
//                                тогда  в информационной базе будет произведена замена
//                                "Свойства.Старые.Ссылка" на "Свойства.Новые.Ссылка". Можно
//                                установить значение Ложь, тогда замена произведена не будет.
//                                 Замена происходит, когда вместо обычного элемента был
//                                добавлен предопределенный элемент или при замене одного
//                                объекта метаданных на другой для безошибочной реструктуризации.
//
Процедура ПриИзмененииИдентификатораОбъектаМетаданных(ВидСобытия, Свойства) Экспорт
	
	
	
КонецПроцедуры

// Возвращает соответствие имен параметров сеанса и обработчиков для их инициализации.
//
Функция ОбработчикиИнициализацииПараметровСеанса() Экспорт
	
	// Для задания обработчиков параметров сеанса следует использовать шаблон:
	// Обработчики.Вставить("<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>", "Обработчик");
	//
	// Примечание. Символ '*'используется в конце имени параметра сеанса и обозначает,
	//             что один обработчик будет вызван для инициализации всех параметров сеанса
	//             с именем, начинающимся на слово НачалоИмениПараметраСеанса
	//
	
	Обработчики = Новый Соответствие;
	
	Возврат Обработчики;
	
КонецФункции

// Устанавливает текстовое описание предмета
//
// Параметры
//  СсылкаНаПредмет  – ЛюбаяСсылка – объект ссылочного типа.
//  Представление	 - Строка - сюда необходимо поместить текстовое описание.
Процедура УстановитьПредставлениеПредмета(СсылкаНаПредмет, Представление) Экспорт
	
КонецПроцедуры

// Заполняет идентификакторы тех объектов метаданных, которые невозможно
// автоматически найти по типу, но которые требуется сохранять в базе данных (например, подсистемы).
//
// Подробнее: см. ОбщегоНазначения.ДобавитьИдентификатор
// 
Процедура ЗаполнитьПредустановленныеИдентификаторыОбъектовМетаданных(Идентификаторы) Экспорт
	
	
	
КонецПроцедуры
