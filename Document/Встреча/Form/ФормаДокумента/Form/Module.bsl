﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Взаимодействия.УстановитьПредметПоДаннымЗаполнения(Параметры, Предмет);
	КонецЕсли;
	Взаимодействия.ЗаполнитьСписокВыбораДляРассмотретьПосле(Элементы.РассмотретьПосле.СписокВыбора);
	
	//Определим типы контактов, которые можно создать
	СписокИнтерактивноСоздаваемыхКонтактов = Взаимодействия.СоздатьСписокЗначенийИнтерактивноСоздаваемыхКонтактов();
	Элементы.СоздатьКонтакт.Видимость      = СписокИнтерактивноСоздаваемыхКонтактов.Количество() > 0;
	
	//подготовить оповещения взаимодействий
	Взаимодействия.ПодготовитьОповещения(ЭтаФорма, Параметры);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, Объект, "СтраницаДополнительныеРеквизиты");
	// Конец СтандартныеПодсистемы.Свойства
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если Не ВебКлиент Тогда
		ПроверитьДоступностьСозданияКонтакта();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ВзаимодействияКлиент.ОтработатьОповещение(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтаФорма, "Встреча");

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, РежимЗаписи, РежимПроведения)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Взаимодействия.ПередЗаписьюВзаимодействияИзФормы(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Взаимодействия.ПриЗаписиВзаимодействияИзФормы(ТекущийОбъект, Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ВзаимодействияКлиент.ВзаимодействиеПредметПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи, "Встреча");
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначения.ПолучитьКартинкуКомментария(Объект.Комментарий);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РассмотретьПослеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ОбработатьВыборВПолеРассмотретьПосле(
		Объект.РассмотретьПосле, ВыбранноеЗначение, СтандартнаяОбработка, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ВыбранноеВремя = ВзаимодействияКлиент.ВыбратьВремя(ЭтаФорма, Элемент, ВремяНачала, 1800);

	Если ВыбранноеВремя = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ВремяНачала = ВыбранноеВремя;

	ВремяНачалаПриИзменении(Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ВыбранноеВремя = ВзаимодействияКлиент.ВыбратьВремя(ЭтаФорма, Элемент, ВремяОкончания, 1800);

	Если ВыбранноеВремя = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ВремяОкончания = ВыбранноеВремя;

	ВремяОкончанияПриИзменении(Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаПриИзменении(Элемент)

	Объект.ДатаНачала = НачалоДня(Объект.ДатаНачала) + ВыделитьВремя(ВремяНачала);
	Объект.ДатаОкончания = Объект.ДатаНачала + Продолжительность;
	ВремяОкончания = Объект.ДатаОкончания;

КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияПриИзменении(Элемент)

	Если НачалоДня(Объект.ДатаОкончания) + ВыделитьВремя(ВремяОкончания) < Объект.ДатаНачала Тогда
		ОчиститьСообщения();
		Сообщить(НСтр("ru='Время окончания не может быть меньше времени начала.'"));
		ВремяОкончания = ВремяНачала + 1800;
		Возврат;
	КонецЕсли;

	Объект.ДатаОкончания = НачалоДня(Объект.ДатаОкончания) + ВыделитьВремя(ВремяОкончания);
	Продолжительность = Объект.ДатаОкончания - Объект.ДатаНачала;

КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)

	Объект.ДатаНачала = НачалоДня(ДатаНачала) + ВыделитьВремя(ВремяНачала);
	Объект.ДатаОкончания = Объект.ДатаНачала + Продолжительность;
	ДатаОкончания = Объект.ДатаОкончания;

КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)

	Если НачалоДня(ДатаОкончания) + ВыделитьВремя(ВремяОкончания) < Объект.ДатаНачала Тогда
		ОчиститьСообщения();
		Сообщить(НСтр("ru='Дата окончания не может быть меньше даты начала.'"));
		ДатаОкончания = Объект.ДатаНачала;
		Возврат;
	КонецЕсли;

	Объект.ДатаОкончания = НачалоДня(ДатаОкончания) + ВыделитьВремя(ВремяОкончания);
	Продолжительность = Объект.ДатаОкончания - Объект.ДатаНачала;

КонецПроцедуры

&НаКлиенте
Процедура РассмотреноПриИзменении(Элемент)
	
	Элементы.РассмотретьПосле.Доступность = НЕ Объект.Рассмотрено;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Участники

&НаКлиенте
Процедура УчастникиПриИзменении(Элемент)
	
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтаФорма, "Встреча");
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПриАктивизацииСтроки(Элемент)
	
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	текДанные = Элементы.Участники.ТекущиеДанные;
	Если ВзаимодействияКлиент.ВыбратьКонтакт(Предмет, текДанные.КакСвязаться, текДанные.ПредставлениеКонтакта,
		                                     текДанные.Контакт, Ложь, Ложь, Истина) Тогда
		
		ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект,ЭтаФорма,"ЗапланированноеВзаимодействие");
		Модифицированность = Истина;
		ПроверитьДоступностьСозданияКонтакта();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеКонтактаПриИзменении(Элемент)
	
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактПриИзменении(Элемент)
	
	ПроверитьДоступностьСозданияКонтакта();
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтаФорма, "Встреча");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьКонтактВыполнить()
	
	текДанные = Элементы.Участники.ТекущиеДанные;
	Если текДанные <> Неопределено Тогда
		ВзаимодействияКлиент.СоздатьКонтакт(
			текДанные.ПредставлениеКонтакта, текДанные.КакСвязаться, Объект.Ссылка, СписокИнтерактивноСоздаваемыхКонтактов
		);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Команды подсистемы свойств 

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПроверитьДоступностьСозданияКонтакта()
	
	текДанные = Элементы.Участники.ТекущиеДанные;
	Элементы.СоздатьКонтакт.Доступность = (Не Объект.Ссылка.Пустая()) И 
		((текДанные <> Неопределено) И (НЕ ЗначениеЗаполнено(текДанные.Контакт)));
	
КонецПроцедуры

&НаКлиенте
Функция ВыделитьВремя(Дата)

	Возврат Час(Дата) * 3600 + Минута(Дата) * 60;

КонецФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ДатаНачала        = Объект.ДатаНачала;
	ВремяНачала       = Объект.ДатаНачала;
	ДатаОкончания     = Объект.ДатаОкончания;
	ВремяОкончания    = Объект.ДатаОкончания;
	Продолжительность = Объект.ДатаОкончания - Объект.ДатаНачала;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Предмет = Взаимодействия.ПолучитьЗначениеПредмета(Объект.Ссылка);
	КонецЕсли;
	
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтаФорма, "Встреча");
	Элементы.РассмотретьПосле.Доступность = НЕ Объект.Рассмотрено;
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначения.ПолучитьКартинкуКомментария(Объект.Комментарий);
	
КонецПроцедуры

