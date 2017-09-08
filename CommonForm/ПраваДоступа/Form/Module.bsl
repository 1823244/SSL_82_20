﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Отказ от инициализации, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Установка заголовка формы.
	Заголовок = УправлениеДоступом.ЗаголовокПодчиненнойФормы(НСтр("ru = 'Права доступа: %1 (%2)'"), Параметры.Пользователь);
	
	ПользовательИБПолноправный = Пользователи.ЭтоПолноправныйПользователь();
	СвойДоступ = Параметры.Пользователь = Пользователи.АвторизованныйПользователь();
	ПользовательИБОтветственный = НЕ ПользовательИБПолноправный И ПравоДоступа("Редактирование", Метаданные.Справочники.ГруппыДоступа);
	
	
	Элементы.ГруппыДоступаКонтекстноеМенюИзменитьГруппу.Видимость = ПользовательИБПолноправный ИЛИ ПользовательИБОтветственный;
	Элементы.ФормаОтчетПраваДоступа.Видимость                     = ПользовательИБПолноправный ИЛИ Параметры.Пользователь = Пользователи.ТекущийПользователь();
	
	// Настройка команды для неполноправного пользователя
	Элементы.ФормаИзменитьГруппу.Видимость            = НЕ ПользовательИБПолноправный И ПользовательИБОтветственный;
	// Настройка команд для полноправного пользователя
	Элементы.ГруппыДоступаВключитьВГруппу.Видимость   =    ПользовательИБПолноправный;
	Элементы.ГруппыДоступаИсключитьИзГруппы.Видимость =    ПользовательИБПолноправный;
	Элементы.ГруппыДоступаИзменитьГруппу.Видимость    =    ПользовательИБПолноправный;
	// Настройка отображения закладок страниц
	Элементы.ГруппыДоступаИРоли.ОтображениеСтраниц    =  ?(ПользовательИБПолноправный, ОтображениеСтраницФормы.ЗакладкиСверху,     ОтображениеСтраницФормы.Нет);
	// Настройка отображения командной панели для полноправного пользователя
	Элементы.ГруппыДоступа.ПоложениеКоманднойПанели   =  ?(ПользовательИБПолноправный, ПоложениеКоманднойПанелиЭлементаФормы.Верх, ПоложениеКоманднойПанелиЭлементаФормы.Нет);
	// Настройка отображения ролей для полноправного пользователя
	Элементы.ОтображениеРолей.Видимость               = ПользовательИБПолноправный;
	
	Если ПользовательИБПолноправный ИЛИ ПользовательИБОтветственный ИЛИ СвойДоступ Тогда
		ВывестиГруппыДоступа();
	Иначе
		// Обычному пользователю запрещено просматривать любые настройки чужого доступа
		Элементы.ГруппыДоступаВключитьВГруппу.Видимость   = Ложь;
		Элементы.ГруппыДоступаИсключитьИзГруппы.Видимость = Ложь;
		//
		Элементы.ГруппыДоступаИРоли.Видимость = Ложь;
		Элементы.НедостаточноПравНаПросмотр.Видимость = Истина;
	КонецЕсли;
	
	//** Установка начальных значений
	//   перед загрузкой данных из настроек на сервере
	//   для случая, когда данные ещё не были записаны и не загружаются
	ПоказатьПодсистемыРолей = Истина;
	Элементы.РолиПоказатьПодсистемыРолей.Пометка = Истина;
	// Выбор ролей не предполагается, поэтому только выбранные роли
	ПоказатьТолькоВыбранныеРоли                      = Истина;
	Элементы.РолиПоказатьТолькоВыбранныеРоли.Пометка = Истина;
	// 
	ОбновитьДеревоРолей();
	
	УстановитьТолькоПросмотрРолей(Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыДоступа")
	 ИЛИ ВРег(ИмяСобытия) = ВРег("Запись_ПрофилиГруппДоступа") Тогда
		
		ВывестиГруппыДоступа();
		РазвернутьПодсистемыРолей();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["ПоказатьПодсистемыРолей"] = Ложь Тогда
		ПоказатьПодсистемыРолей = Ложь;
		Элементы.РолиПоказатьПодсистемыРолей.Пометка = Ложь;
	Иначе
		ПоказатьПодсистемыРолей = Истина;
		Элементы.РолиПоказатьПодсистемыРолей.Пометка = Истина;
	КонецЕсли;
	
	ОбновитьДеревоРолей();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГруппыДоступа

&НаКлиенте
Процедура ГруппыДоступаПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные   = Элементы.ГруппыДоступа.ТекущиеДанные;
	ТекущийРодитель = Элементы.ГруппыДоступа.ТекущийРодитель;
	
	Если ТекущиеДанные = Неопределено Тогда
		ГруппаДоступаИзменена = ЗначениеЗаполнено(ТекущаяГруппаДоступа);
		ТекущаяГруппаДоступа  = Неопределено;
	Иначе
		НоваяГруппаДоступа    = ?(ТекущийРодитель = Неопределено, ТекущиеДанные.ГруппаДоступа, ТекущийРодитель.ГруппаДоступа);
		ГруппаДоступаИзменена = ТекущаяГруппаДоступа <> НоваяГруппаДоступа;
		ТекущаяГруппаДоступа  = НоваяГруппаДоступа;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыДоступаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НайденнаяСтрока = ГруппыДоступа.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если НайденнаяСтрока <> Неопределено Тогда
		Если Элементы.ФормаИзменитьГруппу.Видимость
		 ИЛИ Элементы.ГруппыДоступаИзменитьГруппу.Видимость Тогда
			ИзменитьГруппу(Элементы.ФормаИзменитьГруппу);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Роли

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаКлиенте
Процедура РолиПометкаПриИзменении(Элемент)
	
	Если Элементы.Роли.ТекущиеДанные <> Неопределено Тогда
		ОбновитьСоставРолей(Элементы.Роли.ТекущаяСтрока, Элементы.Роли.ТекущиеДанные.Пометка);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВключитьВГруппу(Команда)
	
	ПараметрыФормы = Новый Структура;
	Выбранные = Новый Массив;
	Для каждого ОписаниеГруппыДоступа Из ГруппыДоступа Цикл
		Выбранные.Добавить(ОписаниеГруппыДоступа.ГруппаДоступа);
	КонецЦикла;
	
	ПараметрыФормы.Вставить("Выбранные",         Выбранные);
	ПараметрыФормы.Вставить("ПользовательГрупп", Параметры.Пользователь);
	НоваяГруппаДоступаПользователя = ОткрытьФормуМодально("Справочник.ГруппыДоступа.Форма.ВыборПоАдминистратору", ПараметрыФормы);
	
	Если ТипЗнч(НоваяГруппаДоступаПользователя) = Тип("СправочникСсылка.ГруппыДоступа")
	   И ЗначениеЗаполнено(НоваяГруппаДоступаПользователя) Тогда
		
		ОписаниеОшибки = "";
		ИзменитьСоставГруппы(НоваяГруппаДоступаПользователя, Истина, ОписаниеОшибки);
		Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			Предупреждение(ОписаниеОшибки);
		Иначе
			ОповеститьОбИзменении(НоваяГруппаДоступаПользователя);
			Оповестить("Запись_ГруппыДоступа", Новый Структура, НоваяГруппаДоступаПользователя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьИзГруппы(Команда)
	
	Если НЕ ЗначениеЗаполнено(ТекущаяГруппаДоступа) Тогда
		Предупреждение(НСтр("ru = 'Группа доступа не выбрана.'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	ИзменитьСоставГруппы(ТекущаяГруппаДоступа, Ложь, ОписаниеОшибки);
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Предупреждение(ОписаниеОшибки);
	Иначе
		ОповеститьОбИзменении(ТекущаяГруппаДоступа);
		Оповестить("Запись_ГруппыДоступа", Новый Структура, ТекущаяГруппаДоступа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьГруппу(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	Если НЕ ЗначениеЗаполнено(ТекущаяГруппаДоступа) Тогда
		Предупреждение(НСтр("ru = 'Группа доступа не выбрана.'"));
		Возврат;
		
	ИначеЕсли НЕ (ПользовательИБПолноправный
	              ИЛИ ПользовательИБОтветственный
	                  И РазрешеноИзменениеСоставаПользователейГруппы(ТекущаяГруппаДоступа) ) Тогда
		//
		Предупреждение(НСтр("ru = 'Невозможно изменить группу доступа,
		                          |так как текущий пользователь
		                          |не администратор участников группы доступа и
		                          |не полноправный администратор.'"));
		Возврат;
		
	Иначе
		ПараметрыФормы.Вставить("Ключ", ТекущаяГруппаДоступа);
		ОткрытьФорму("Справочник.ГруппыДоступа.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ВывестиГруппыДоступа();
	РазвернутьПодсистемыРолей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоПравамДоступа(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователь", Параметры.Пользователь);
	ОткрытьФорму("Отчет.ПраваДоступа.Форма", ПараметрыФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаКлиенте
Процедура ПоказатьТолькоВыбранныеРоли(Команда)
	
	ПоказатьТолькоВыбранныеРоли = НЕ ПоказатьТолькоВыбранныеРоли;
	Элементы.РолиПоказатьТолькоВыбранныеРоли.Пометка = ПоказатьТолькоВыбранныеРоли;
	
	ОбновитьДеревоРолей();
	РазвернутьПодсистемыРолей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодсистемыРолей(Команда)
	
	ПоказатьПодсистемыРолей = НЕ ПоказатьПодсистемыРолей;
	Элементы.РолиПоказатьПодсистемыРолей.Пометка = ПоказатьПодсистемыРолей;
	
	ОбновитьДеревоРолей();
	РазвернутьПодсистемыРолей();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	ОбновитьСоставРолей(Неопределено, Истина);
	Если ПоказатьТолькоВыбранныеРоли Тогда
		РазвернутьПодсистемыРолей();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	ОбновитьСоставРолей(Неопределено, Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ВывестиГруппыДоступа()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Если ПользовательИБПолноправный ИЛИ СвойДоступ Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГруппыДоступа.Ссылка
	|ПОМЕСТИТЬ РазрешенныеГруппыДоступа
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа";
	Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазрешенныеГруппыДоступа.Ссылка
	|ИЗ
	|	РазрешенныеГруппыДоступа КАК РазрешенныеГруппыДоступа
	|ГДЕ
	|	(НЕ РазрешенныеГруппыДоступа.Ссылка.ПометкаУдаления)
	|	И (НЕ РазрешенныеГруппыДоступа.Ссылка.Профиль.ПометкаУдаления)";
	РазрешенныеГруппыДоступа = Запрос.Выполнить().Выгрузить();
	РазрешенныеГруппыДоступа.Индексы.Добавить("Ссылка");
	
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК ГруппаДоступа,
	|	ГруппыДоступа.Ссылка.Наименование КАК Наименование,
	|	ГруппыДоступа.Ссылка.Профиль.Наименование КАК ПрофильНаименование,
	|	ГруппыДоступа.Ссылка.Описание КАК Описание,
	|	ГруппыДоступа.Ссылка.Администратор КАК Администратор
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ГруппыДоступа.Ссылка КАК Ссылка
	|	ИЗ
	|		Справочник.ГруппыДоступа КАК ГруппыДоступа
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ПользователиГруппДоступа
	|			ПО (ПользователиГруппДоступа.Пользователь В
	|					(ВЫБРАТЬ
	|						&Пользователь
	|				
	|					ОБЪЕДИНИТЬ
	|				
	|					ВЫБРАТЬ
	|						ГруппыПользователей.ГруппаДоступа
	|					ИЗ
	|						РегистрСведений.ГруппыЗначенийДоступа КАК ГруппыПользователей
	|					ГДЕ
	|						ГруппыПользователей.ВидДоступа = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПустаяСсылка)
	|						И ГруппыПользователей.ЗначениеДоступа = &Пользователь))
	|				И ГруппыДоступа.Ссылка = ПользователиГруппДоступа.Ссылка
	|				И (НЕ ГруппыДоступа.ПометкаУдаления)
	|				И (НЕ ГруппыДоступа.Профиль.ПометкаУдаления)) КАК ГруппыДоступа
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппыДоступа.Ссылка.Наименование";
	
	ВсеГруппыДоступа = Запрос.Выполнить().Выгрузить();
	
	// Установка представления для группы доступа
	// Удаление текущего пользователя из группы доступа, если он входит в нее только непосредственно
	ЕстьЗапрещенныеГруппы = Ложь;
	Индекс = ВсеГруппыДоступа.Количество()-1;
	Пока Индекс >= 0 Цикл
		Строка = ВсеГруппыДоступа[Индекс];
		Если РазрешенныеГруппыДоступа.Найти(Строка.ГруппаДоступа, "Ссылка") = Неопределено Тогда
			ВсеГруппыДоступа.Удалить(Индекс);
			ЕстьЗапрещенныеГруппы = Истина;
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	ЗначениеВРеквизитФормы(ВсеГруппыДоступа, "ГруппыДоступа");
	Элементы.ПредупреждениеЕстьСкрытыеГруппыДоступа.Видимость = ЕстьЗапрещенныеГруппы;
	
	Если НЕ ЗначениеЗаполнено(ТекущаяГруппаДоступа) Тогда
		Если ГруппыДоступа.Количество() > 0 Тогда
			ТекущаяГруппаДоступа = ГруппыДоступа[0].ГруппаДоступа;
		КонецЕсли;
	КонецЕсли;
	
	Для каждого ОписаниеГруппыДоступа Из ГруппыДоступа Цикл
		Если ОписаниеГруппыДоступа.ГруппаДоступа = ТекущаяГруппаДоступа Тогда
			Элементы.ГруппыДоступа.ТекущаяСтрока = ОписаниеГруппыДоступа.ПолучитьИдентификатор();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПользовательИБПолноправный Тогда
		ЗаполнитьРоли();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьСоставГруппы(Знач ГруппаДоступа, Знач Добавить, ОписаниеОшибки = "")
	
	Если НЕ РазрешеноИзменениеСоставаПользователейГруппы(ГруппаДоступа) Тогда
		Если Добавить Тогда
			ОписаниеОшибки = НСтр("ru = 'Невозможно включить пользователя в группу доступа,
			                            |так как текущий пользователь
			                            |не администратор участников группы доступа и
			                            |не полноправный администратор.'");
		Иначе
			ОписаниеОшибки = НСтр("ru = 'Невозможно исключить пользователя из группы доступа,
			                            |так как текущий пользователь
			                            |не администратор участников группы доступа и
			                            |не полноправный администратор.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если НЕ Добавить И НЕ ПользовательВключенВГруппуДоступа(ТекущаяГруппаДоступа) Тогда
		ОписаниеОшибки =  НСтр("ru = 'Невозможно исключить пользователя из группы доступа,
		                             |так как он включен в нее косвенно.'");
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ГруппаДоступаОбъект = ГруппаДоступа.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ГруппаДоступаОбъект.Ссылка, ГруппаДоступаОбъект.ВерсияДанных);
	Если Добавить Тогда
		Если ГруппаДоступаОбъект.Пользователи.Найти(Параметры.Пользователь, "Пользователь") = Неопределено Тогда
			ГруппаДоступаОбъект.Пользователи.Добавить().Пользователь = Параметры.Пользователь;
		КонецЕсли;
	Иначе
		СтрокаТЧ = ГруппаДоступаОбъект.Пользователи.Найти(Параметры.Пользователь, "Пользователь");
		Если СтрокаТЧ <> Неопределено Тогда
			ГруппаДоступаОбъект.Пользователи.Удалить(СтрокаТЧ);
		КонецЕсли;
	КонецЕсли;
	
	Если ГруппаДоступаОбъект.Ссылка = Справочники.ГруппыДоступа.Администраторы Тогда
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменение состава администраторов выполняется
			           |непосредственно в группе доступа %1.'"),
			ГруппаДоступаОбъект.Наименование);
	Иначе
		ГруппаДоступаОбъект.Записать();
	КонецЕсли;
	
	РазблокироватьДанныеДляРедактирования(ГруппаДоступаОбъект.Ссылка);
	
	ТекущаяГруппаДоступа = ГруппаДоступаОбъект.Ссылка;
	
КонецПроцедуры

&НаСервере
Функция РазрешеноИзменениеСоставаПользователейГруппы(ГруппаДоступа)
	
	Если ПользовательИБПолноправный Тогда
		Возврат Истина;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаДоступа",              ГруппаДоступа);
	Запрос.УстановитьПараметр("АвторизованныйПользователь", Пользователи.АвторизованныйПользователь());
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГруппыЗначенийДоступа КАК ПользователиИГруппыПользователей
	|		ПО (ПользователиИГруппыПользователей.ВидДоступа = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПустаяСсылка))
	|			И (ПользователиИГруппыПользователей.ЗначениеДоступа = &АвторизованныйПользователь)
	|			И (ПользователиИГруппыПользователей.ТолькоВидДоступа = ЛОЖЬ)
	|			И (ПользователиИГруппыПользователей.ГруппаДоступа = ГруппыДоступа.Администратор)
	|			И (ГруппыДоступа.Администратор <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
	|			И (ГруппыДоступа.Ссылка = &ГруппаДоступа)";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Функция ПользовательВключенВГруппуДоступа(ГруппаДоступа)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаДоступа", ГруппаДоступа);
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|ГДЕ
	|	ГруппыДоступаПользователи.Ссылка = &ГруппаДоступа
	|	И ГруппыДоступаПользователи.Пользователь = &Пользователь";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции


&НаСервере
Процедура ЗаполнитьРоли()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	
	Если ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.Пользователи")
	 ИЛИ ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		//
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Роли.Роль
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа.Роли КАК Роли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГруппыЗначенийДоступа КАК ПользователиИГруппыПользователей
		|			ПО (ПользователиИГруппыПользователей.ВидДоступа = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПустаяСсылка))
		|				И (ПользователиИГруппыПользователей.ЗначениеДоступа = &Пользователь)
		|				И (ПользователиИГруппыПользователей.ТолькоВидДоступа = ЛОЖЬ)
		|				И (ПользователиИГруппыПользователей.ГруппаДоступа = ГруппыДоступаПользователи.Пользователь)
		|				И ((НЕ ГруппыДоступаПользователи.Ссылка.ПометкаУдаления))
		|		ПО Роли.Ссылка = ГруппыДоступаПользователи.Ссылка.Профиль
		|			И ((НЕ Роли.Ссылка.ПометкаУдаления))";
	Иначе
		// Группа пользователей или
		// Группа внешних пользователей
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Роли.Роль
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа.Роли КАК Роли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ПО (ГруппыДоступаПользователи.Пользователь = &Пользователь)
		|			И ((НЕ ГруппыДоступаПользователи.Ссылка.ПометкаУдаления))
		|			И Роли.Ссылка = ГруппыДоступаПользователи.Ссылка.Профиль
		|			И ((НЕ Роли.Ссылка.ПометкаУдаления))";
	КонецЕсли;
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(), "ПрочитанныеРоли");
	
	ОбновитьДеревоРолей();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаСервере
Функция КоллекцияРолей(ТаблицаЗначенийДляЧтения = Ложь)
	
	Если ТаблицаЗначенийДляЧтения Тогда
		Возврат РеквизитФормыВЗначение("ПрочитанныеРоли");
	КонецЕсли;
	
	Возврат ПрочитанныеРоли;
	
	
КонецФункции

&НаСервере
Процедура УстановитьТолькоПросмотрРолей(Знач ТолькоПросмотрРолей = Неопределено, Знач РазрешитьПросмотрТолькоВыбранных = Ложь)
	
	Если ТолькоПросмотрРолей <> Неопределено Тогда
		Элементы.Роли.ТолькоПросмотр              =    ТолькоПросмотрРолей;
		Элементы.РолиУстановитьФлажки.Доступность = НЕ ТолькоПросмотрРолей;
		Элементы.РолиСнятьФлажки.Доступность      = НЕ ТолькоПросмотрРолей;
	КонецЕсли;
	
	Если РазрешитьПросмотрТолькоВыбранных Тогда
		Элементы.РолиПоказатьТолькоВыбранныеРоли.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьПодсистемыРолей(Коллекция = Неопределено);
	
	Если Коллекция = Неопределено Тогда
		Коллекция = Роли.ПолучитьЭлементы();
	КонецЕсли;
	
	// Развернуть все
	Для каждого Строка ИЗ Коллекция Цикл
		Элементы.Роли.Развернуть(Строка.ПолучитьИдентификатор());
		Если НЕ Строка.ЭтоРоль Тогда
			РазвернутьПодсистемыРолей(Строка.ПолучитьЭлементы());
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоРолей()
	
	Если НЕ Элементы.РолиПоказатьТолькоВыбранныеРоли.Доступность Тогда
		Элементы.РолиПоказатьТолькоВыбранныеРоли.Пометка = Истина;
		ПоказатьТолькоВыбранныеРоли = Истина;
	КонецЕсли;
	
	// Запоминание текущей строки
	ТекущаяПодсистема = "";
	ТекущаяРоль       = "";
	//
	Если Элементы.Роли.ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Роли.НайтиПоИдентификатору(Элементы.Роли.ТекущаяСтрока);
		Если ТекущиеДанные.ЭтоРоль Тогда
			ТекущаяПодсистема = ?(ТекущиеДанные.ПолучитьРодителя() = Неопределено, "", ТекущиеДанные.ПолучитьРодителя().Имя);
			ТекущаяРоль       = ТекущиеДанные.Имя;
		Иначе
			ТекущаяПодсистема = ТекущиеДанные.Имя;
			ТекущаяРоль       = "";
		КонецЕсли;
	КонецЕсли;
	
	ДеревоРолей = ПользователиСерверПовтИсп.ДеревоРолей(ПоказатьПодсистемыРолей).Скопировать();
	ДобавитьИменаНесуществующихРолей(ДеревоРолей);
	ДеревоРолей.Колонки.Добавить("Пометка",       Новый ОписаниеТипов("Булево"));
	ДеревоРолей.Колонки.Добавить("НомерКартинки", Новый ОписаниеТипов("Число"));
	ПодготовитьДеревоРолей(ДеревоРолей.Строки, СкрытьРольПолныеПрава, ПоказатьТолькоВыбранныеРоли);
	
	ЗначениеВРеквизитФормы(ДеревоРолей, "Роли");
	
	Элементы.Роли.Отображение = ?(ДеревоРолей.Строки.Найти(Ложь, "ЭтоРоль") = Неопределено, ОтображениеТаблицы.Список, ОтображениеТаблицы.Дерево);
	
	// Восстановление текущей строки
	НайденныеСтроки = ДеревоРолей.Строки.НайтиСтроки(Новый Структура("ЭтоРоль, Имя", Ложь, ТекущаяПодсистема), Истина);
	Если НайденныеСтроки.Количество() <> 0 Тогда
		ОписаниеПодсистемы = НайденныеСтроки[0];
		ИндексПодсистемы = ?(ОписаниеПодсистемы.Родитель = Неопределено, ДеревоРолей.Строки, ОписаниеПодсистемы.Родитель.Строки).Индекс(ОписаниеПодсистемы);
		СтрокаПодсистемы = ДанныеФормыКоллекцияЭлементовДерева(Роли, ОписаниеПодсистемы).Получить(ИндексПодсистемы);
		Если ЗначениеЗаполнено(ТекущаяРоль) Тогда
			НайденныеСтроки = ОписаниеПодсистемы.Строки.НайтиСтроки(Новый Структура("ЭтоРоль, Имя", Истина, ТекущаяРоль));
			Если НайденныеСтроки.Количество() <> 0 Тогда
				ОписаниеРоли = НайденныеСтроки[0];
				Элементы.Роли.ТекущаяСтрока = СтрокаПодсистемы.ПолучитьЭлементы().Получить(ОписаниеПодсистемы.Строки.Индекс(ОписаниеРоли)).ПолучитьИдентификатор();
			Иначе
				Элементы.Роли.ТекущаяСтрока = СтрокаПодсистемы.ПолучитьИдентификатор();
			КонецЕсли;
		Иначе
			Элементы.Роли.ТекущаяСтрока = СтрокаПодсистемы.ПолучитьИдентификатор();
		КонецЕсли;
	Иначе
		НайденныеСтроки = ДеревоРолей.Строки.НайтиСтроки(Новый Структура("ЭтоРоль, Имя", Истина, ТекущаяРоль), Истина);
		Если НайденныеСтроки.Количество() <> 0 Тогда
			ОписаниеРоли = НайденныеСтроки[0];
			ИндексРоли = ?(ОписаниеРоли.Родитель = Неопределено, ДеревоРолей.Строки, ОписаниеРоли.Родитель.Строки).Индекс(ОписаниеРоли);
			СтрокаРоли = ДанныеФормыКоллекцияЭлементовДерева(Роли, ОписаниеРоли).Получить(ИндексРоли);
			Элементы.Роли.ТекущаяСтрока = СтрокаРоли.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьДеревоРолей(Знач Коллекция, Знач СкрытьРольПолныеПрава, Знач ПоказатьТолькоВыбранныеРоли)
	
	Индекс = Коллекция.Количество()-1;
	
	Пока Индекс >= 0 Цикл
		Строка = Коллекция[Индекс];
		
		ПодготовитьДеревоРолей(Строка.Строки, СкрытьРольПолныеПрава, ПоказатьТолькоВыбранныеРоли);
		
		Если Строка.ЭтоРоль Тогда
			Если СкрытьРольПолныеПрава И 
				(ВРег(Строка.Имя) = ВРег("ПолныеПрава") ИЛИ ВРег(Строка.Имя) = ВРег("АдминистраторСистемы")) Тогда
				Коллекция.Удалить(Индекс);
			Иначе
				Строка.НомерКартинки = 6;
				Строка.Пометка = КоллекцияРолей().НайтиСтроки(Новый Структура("Роль", Строка.Имя)).Количество() > 0;
				Если ПоказатьТолькоВыбранныеРоли И НЕ Строка.Пометка Тогда
					Коллекция.Удалить(Индекс);
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если Строка.Строки.Количество() = 0 Тогда
				Коллекция.Удалить(Индекс);
			Иначе
				Строка.НомерКартинки = 5;
				Строка.Пометка = Строка.Строки.НайтиСтроки(Новый Структура("Пометка", Ложь)).Количество() = 0;
			КонецЕсли;
		КонецЕсли;
		
		Индекс = Индекс-1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДанныеФормыКоллекцияЭлементовДерева(Знач ДанныеФормыДерево, Знач СтрокаДереваЗначений)
	
	Если СтрокаДереваЗначений.Родитель = Неопределено Тогда
		ДанныеФормыКоллекцияЭлементовДерева = ДанныеФормыДерево.ПолучитьЭлементы();
	Иначе
		ИндексРодителя = ?(СтрокаДереваЗначений.Родитель.Родитель = Неопределено, СтрокаДереваЗначений.Владелец().Строки, СтрокаДереваЗначений.Родитель.Родитель.Строки).Индекс(СтрокаДереваЗначений.Родитель);
		ДанныеФормыКоллекцияЭлементовДерева = ДанныеФормыКоллекцияЭлементовДерева(ДанныеФормыДерево, СтрокаДереваЗначений.Родитель).Получить(ИндексРодителя).ПолучитьЭлементы();
	КонецЕсли;
	
	Возврат ДанныеФормыКоллекцияЭлементовДерева;
	
КонецФункции


&НаСервере
Процедура ОбновитьСоставРолей(ИдентификаторСтроки, Добавить);
	
	Если ИдентификаторСтроки = Неопределено Тогда
		// Обработка всех
		КоллекцияРолей = КоллекцияРолей();
		КоллекцияРолей.Очистить();
		Если Добавить Тогда
			ВсеРоли = ПользователиСерверПовтИсп.ВсеРоли();
			Для каждого ОписаниеРоли Из ВсеРоли Цикл
				Если ОписаниеРоли.Имя <> "ПолныеПрава" И ОписаниеРоли.Имя <> "АдминистраторСистемы" Тогда
					КоллекцияРолей.Добавить().Роль = ОписаниеРоли.Имя;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если ПоказатьТолькоВыбранныеРоли Тогда
			Если КоллекцияРолей.Количество() > 0 Тогда
				ОбновитьДеревоРолей();
			Иначе
				Роли.ПолучитьЭлементы().Очистить();
			КонецЕсли;
			// Возврат
			Возврат;
			// Возврат
		КонецЕсли;
	Иначе
		ТекущиеДанные = Роли.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ТекущиеДанные.ЭтоРоль Тогда
			ДобавитьУдалитьРоль(ТекущиеДанные.Имя, Добавить);
		Иначе
			ДобавитьУдалитьРолиПодсистемы(ТекущиеДанные.ПолучитьЭлементы(), Добавить);
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьПометкуВыбранныхРолей(Роли.ПолучитьЭлементы());
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьУдалитьРоль(Знач Роль, Знач Добавить)
	
	НайденныеРоли = КоллекцияРолей().НайтиСтроки(Новый Структура("Роль", Роль));
	
	Если Добавить Тогда
		Если НайденныеРоли.Количество() = 0 Тогда
			КоллекцияРолей().Добавить().Роль = Роль;
		КонецЕсли;
	Иначе
		Если НайденныеРоли.Количество() > 0 Тогда
			КоллекцияРолей().Удалить(НайденныеРоли[0]);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьУдалитьРолиПодсистемы(Знач Коллекция, Знач Добавить)
	
	Для каждого Строка Из Коллекция Цикл
		Если Строка.ЭтоРоль Тогда
			ДобавитьУдалитьРоль(Строка.Имя, Добавить);
		Иначе
			ДобавитьУдалитьРолиПодсистемы(Строка.ПолучитьЭлементы(), Добавить);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПометкуВыбранныхРолей(Знач Коллекция)
	
	Индекс = Коллекция.Количество()-1;
	
	Пока Индекс >= 0 Цикл
		Строка = Коллекция[Индекс];
		
		Если Строка.ЭтоРоль Тогда
			Строка.Пометка = КоллекцияРолей().НайтиСтроки(Новый Структура("Роль", Строка.Имя)).Количество() > 0;
			Если ПоказатьТолькоВыбранныеРоли И НЕ Строка.Пометка Тогда
				Коллекция.Удалить(Индекс);
			КонецЕсли;
		Иначе
			ОбновитьПометкуВыбранныхРолей(Строка.ПолучитьЭлементы());
			Если Строка.ПолучитьЭлементы().Количество() = 0 Тогда
				Коллекция.Удалить(Индекс);
			Иначе
				Строка.Пометка = Истина;
				Для каждого Элемент Из Строка.ПолучитьЭлементы() Цикл
					Если НЕ Элемент.Пометка Тогда
						Строка.Пометка = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Индекс = Индекс-1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьИменаНесуществующихРолей(ДеревоРолей)
	
	// Добавление несуществующих ролей
	Для каждого Строка Из КоллекцияРолей() Цикл
		Если ДеревоРолей.Строки.НайтиСтроки(Новый Структура("ЭтоРоль, Имя", Истина, Строка.Роль), Истина).Количество() = 0 Тогда
			СтрокаДерева = ДеревоРолей.Строки.Вставить(0);
			СтрокаДерева.ЭтоРоль       = Истина;
			СтрокаДерева.Имя           = Строка.Роль;
			СтрокаДерева.Синоним       = "? " + Строка.Роль;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
