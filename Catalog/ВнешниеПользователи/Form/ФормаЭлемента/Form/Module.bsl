﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//** Установка начальных значений
	//   перед загрузкой данных из настроек на сервере
	//   для случая, когда данные ещё не были записаны и не загружаются
	ПоказатьПодсистемыРолей = Истина;
	Элементы.РолиПоказатьПодсистемыРолей.Пометка = Истина;
	// Для нового элемента показать все роли, иначе только выбранные
	ПоказатьТолькоВыбранныеРоли                      = ЗначениеЗаполнено(Объект.Ссылка);
	Элементы.РолиПоказатьТолькоВыбранныеРоли.Пометка = ЗначениеЗаполнено(Объект.Ссылка);
	//
	СкрытьРольПолныеПрава = Истина;
	ОбновитьДеревоРолей();
	
	
	//** Заполнение постоянных данных
	ЗапретРедактированияРолей = ПользователиПереопределяемый.ЗапретРедактированияРолей();
	АвторизованПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	
	// Заполнение списка выбора языка
	Для каждого МетаданныеЯзыка ИЗ Метаданные.Языки Цикл
		Элементы.ПредставлениеЯзыка.СписокВыбора.Добавить(МетаданныеЯзыка.Синоним);
	КонецЦикла;
	
	//** Подготовка к интерактивным действиям с учетом сценариев открытия формы
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		// Создание нового элемента
		Если Параметры.ГруппаНовогоВнешнегоПользователя <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			ГруппаНовогоВнешнегоПользователя = Параметры.ГруппаНовогоВнешнегоПользователя;
		КонецЕсли;
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			// Копирование элемента
			Объект.ОбъектАвторизации = Неопределено;
			Объект.Наименование      = "";
			Объект.Код               = "";
			Объект.УдалитьПароль     = "";
			ПрочитатьПользователяИБ(ЗначениеЗаполнено(Параметры.ЗначениеКопирования.ИдентификаторПользователяИБ));
		Иначе
			// Добавление элемента
			Если Параметры.Свойство("ОбъектАвторизацииНовогоВнешнегоПользователя") Тогда
				Объект.ОбъектАвторизации = Параметры.ОбъектАвторизацииНовогоВнешнегоПользователя;
				ОбъектАвторизацииЗаданПриОткрытии = ЗначениеЗаполнено(Объект.ОбъектАвторизации);
				ОбъектАвторизацииПриИзмененииНаКлиентеНаСервере(ЭтаФорма, Объект);
			ИначеЕсли ЗначениеЗаполнено(ГруппаНовогоВнешнегоПользователя) Тогда
				ТипОбъектовАвторизации = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ГруппаНовогоВнешнегоПользователя, "ТипОбъектовАвторизации");
				Объект.ОбъектАвторизации = ТипОбъектовАвторизации;
				Элементы.ОбъектАвторизации.ВыбиратьТип = ТипОбъектовАвторизации = Неопределено;
			КонецЕсли;
			// Чтение начальных значений свойств пользователя ИБ
			ПрочитатьПользователяИБ();
		КонецЕсли;
	Иначе
		// Открытие существующего элемента
		ПрочитатьПользователяИБ();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОпределитьДействияВФорме();
	
	ОпределитьНесоответствияПользователяСПользователемИБ();
	
	//** Установка постоянной доступности свойств
	Элементы.СвойстваПользователяИБ.Видимость          = ЗначениеЗаполнено(ДействияВФорме.СвойстваПользователяИБ);
	Элементы.ОтображениеРолей.Видимость                = ЗначениеЗаполнено(ДействияВФорме.Роли);
	Элементы.УстановитьРолиНепосредственно.Видимость   = ЗначениеЗаполнено(ДействияВФорме.Роли) И НЕ ПользователиПереопределяемый.ЗапретРедактированияРолей();
	
	Элементы.УстановитьРолиНепосредственно.Доступность = ДействияВФорме.Роли = "Редактирование";
	
	ТолькоПросмотр = ТолькоПросмотр ИЛИ
	                 ДействияВФорме.Роли <> "Редактирование" И
	                 НЕ ( ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех" ИЛИ
	                      ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих"     ) И
	                 ДействияВФорме.СвойстваЭлемента <> "Редактирование";
	
	Если НЕ ПользователиСерверПовтИсп.АутентификацияOpenIDНастраивается() Тогда
		Элементы.ПользовательИнфБазыАутентификацияOpenID.Видимость = Ложь;
		Элементы.ПользовательИнфБазыАутентификацияСтандартная.Видимость = Ложь;
		Элементы.СвойстваПараметрыАутентификации1СПредприятия.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТекущееПредставлениеОбъектаАвторизации = Строка(Объект.ОбъектАвторизации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ)
	
	ОчиститьСообщения();
	
	Если ДействияВФорме.Роли = "Редактирование" И Объект.УстановитьРолиНепосредственно И ПользовательИнфБазыРоли.Количество() = 0 Тогда
		
		Ответ = Вопрос(НСтр("ru = 'Пользователю информационной базы не установлено ни одной роли. Продолжить?'"),
		            РежимДиалогаВопрос.ДаНет, , , НСтр("ru = 'Запись пользователя информационной базы'"));
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ДействияВФорме.СвойстваЭлемента <> "Редактирование" Тогда
		ЗаполнитьЗначенияСвойств(ТекущийОбъект, ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ТекущийОбъект.Ссылка, "Наименование, ПометкаУдаления"));
	КонецЕсли;
	
	Если ВнешниеПользователи.ОбъектАвторизацииИспользуется(Объект.ОбъектАвторизации, Объект.Ссылка) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						НСтр("ru = 'Объект информационной базы уже используется для другого внешнего пользователя.'"), ,
						"Объект.ОбъектАвторизации", ,
						Отказ);
		Возврат;
	КонецЕсли;
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ГруппаНовогоВнешнегоПользователя", ГруппаНовогоВнешнегоПользователя);
	
	Если ДоступКИнформационнойБазеРазрешен Тогда
		
		ЗаписатьПользователяИБ(ТекущийОбъект, Отказ);
		Если НЕ Отказ Тогда
			Если ТекущийОбъект.ИдентификаторПользователяИБ <> СтарыйИдентификаторПользователяИБ Тогда
				ПараметрыЗаписи.Вставить("ДобавленПользовательИБ", ТекущийОбъект.ИдентификаторПользователяИБ);
			Иначе
				ПараметрыЗаписи.Вставить("ИзмененПользовательИБ", ТекущийОбъект.ИдентификаторПользователяИБ);
			КонецЕсли
		КонецЕсли;
		
	ИначеЕсли НЕ ЕстьСвязьСНесуществующимПользователемИБ ИЛИ
	          ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех" Тогда
		
		ТекущийОбъект.ИдентификаторПользователяИБ = Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущееПредставлениеОбъектаАвторизации = Строка(ТекущийОбъект.ОбъектАвторизации);
	ТекущийОбъект.Наименование = ТекущееПредставлениеОбъектаАвторизации;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ДоступКИнформационнойБазеРазрешен И ПользовательИБСуществует Тогда
		УдалитьПользователяИБ(Отказ);
		Если НЕ Отказ Тогда
			ПараметрыЗаписи.Вставить("УдаленПользовательИБ", СтарыйИдентификаторПользователяИБ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПрочитатьПользователяИБ();
	
	ОпределитьНесоответствияПользователяСПользователемИБ(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВнешниеПользователи", Новый Структура, Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ДобавленПользовательИБ") Тогда
		Оповестить("ДобавленПользовательИБ", ПараметрыЗаписи.ДобавленПользовательИБ, ЭтаФорма);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("ИзмененПользовательИБ") Тогда
		Оповестить("ИзмененПользовательИБ", ПараметрыЗаписи.ИзмененПользовательИБ, ЭтаФорма);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("УдаленПользовательИБ") Тогда
		Оповестить("УдаленПользовательИБ", ПараметрыЗаписи.УдаленПользовательИБ, ЭтаФорма);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("ОчищенаСвязьСНесуществущимПользователемИБ") Тогда
		Оповестить("ОчищенаСвязьСНесуществущимПользователемИБ", ПараметрыЗаписи.ОчищенаСвязьСНесуществущимПользователемИБ, ЭтаФорма);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГруппаНовогоВнешнегоПользователя) Тогда
		ОповеститьОбИзменении(ГруппаНовогоВнешнегоПользователя);
		Оповестить("Запись_ГруппыВнешнихПользователей", Новый Структура, ГруппаНовогоВнешнегоПользователя);
		ГруппаНовогоВнешнегоПользователя = Неопределено;
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
	РазвернутьПодсистемыРолей();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ДоступКИнформационнойБазеРазрешен Тогда
		
		Если НЕ Отказ И ПустаяСтрока(ПользовательИнфБазыИмя) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено имя пользователя информационной базы.'"),
				,
				"ПользовательИнфБазыИмя",
				,
				Отказ);
		КонецЕсли;
		
		Если НЕ Отказ И ПользовательИнфБазыПароль <> Неопределено  И Пароль <> ПодтверждениеПароля Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Пароль и подтверждение пароля не совпадают.'"),
				,
				"Пароль",
				,
				Отказ);
		КонецЕсли;
		
		Если ТребуетсяСоздатьПервогоАдминистратора() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Первый пользователь информационной базы должен иметь полные права.
				           |Внешний пользователь не может быть полноправным.
				           |Сначала создайте обычного пользователя-администратора.'"),
				,
				"ДоступКИнформационнойБазеРазрешен",
				,
				Отказ);
		КонецЕсли;
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
	
	СкрытьРольПолныеПрава = Истина;
	ОбновитьДеревоРолей();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОбъектАвторизацииПриИзменении(Элемент)
	
	ОбъектАвторизацииПриИзмененииНаКлиентеНаСервере(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступКИнформационнойБазеРазрешенПриИзменении(Элемент)
	
	Если НЕ ПользовательИБСуществует И ДоступКИнформационнойБазеРазрешен Тогда
		ПользовательИнфБазыИмя = ПолучитьКраткоеИмяПользователяИБ(ТекущееПредставлениеОбъектаАвторизации);
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыАутентификацияСтандартнаяПриИзменении(Элемент)
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ПользовательИнфБазыПароль = Пароль;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРолиНепосредственноПриИзменении(Элемент)
	
	Если НЕ Объект.УстановитьРолиНепосредственно Тогда
		ПрочитатьПользователяИБ(, Истина);
		РазвернутьПодсистемыРолей();
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
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
Функция ТребуетсяСоздатьПервогоАдминистратора()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() = 0;
	
КонецФункции

&НаСервере
Процедура ОпределитьДействияВФорме()
	
	ДействияВФорме = Новый Структура;
	ДействияВФорме.Вставить("Роли",                   ""); // "", "Просмотр",     "Редактирование"
	ДействияВФорме.Вставить("СвойстваПользователяИБ", ""); // "", "ПросмотрВсех", "РедактированиеВсех", "РедактированиеСвоих"
	ДействияВФорме.Вставить("СвойстваЭлемента",       ""); // "", "Просмотр",     "Редактирование"
	
	Если Пользователи.ЭтоПолноправныйПользователь() ИЛИ
	     ПравоДоступа("Добавление", Метаданные.Справочники.Пользователи) Тогда
		// Администратор
		ДействияВФорме.Роли                   = "Редактирование";
		ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех";
		ДействияВФорме.СвойстваЭлемента       = "Редактирование";
		
	ИначеЕсли РольДоступна("ДобавлениеИзменениеВнешнихПользователей") Тогда
		// Менеджер внешних пользователей
		ДействияВФорме.Роли                   = "";
		ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех";
		ДействияВФорме.СвойстваЭлемента       = "Просмотр";
		
	ИначеЕсли ЗначениеЗаполнено(ВнешниеПользователи.ТекущийВнешнийПользователь()) И
	          Объект.Ссылка = ВнешниеПользователи.ТекущийВнешнийПользователь() Тогда
		// Свои свойства
		ДействияВФорме.Роли                   = "";
		ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих";
		ДействияВФорме.СвойстваЭлемента       = "Просмотр";
	Иначе
		// Читатель внешних пользователей
		ДействияВФорме.Роли                   = "";
		ДействияВФорме.СвойстваПользователяИБ = "";
		ДействияВФорме.СвойстваЭлемента       = "Просмотр";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ ЗначениеЗаполнено(Объект.ОбъектАвторизации) Тогда
		ДействияВФорме.СвойстваЭлемента       = "Редактирование";
	КонецЕсли;
	
	ПользователиПереопределяемый.ИзменитьДействияВФорме(Объект.Ссылка, ДействияВФорме);
	
	// Проверка имен действий в форме
	Если Найти(", Просмотр, Редактирование,", ", " + ДействияВФорме.Роли + ",") = 0 Тогда
		ДействияВФорме.Роли = "";
	ИначеЕсли ПользователиПереопределяемый.ЗапретРедактированияРолей() Тогда
		ДействияВФорме.Роли = "Просмотр";
	КонецЕсли;
	Если Найти(", ПросмотрВсех, РедактированиеВсех, РедактированиеСвоих,", ", " + ДействияВФорме.СвойстваПользователяИБ + ",") = 0 Тогда
		ДействияВФорме.СвойстваПользователяИБ = "";
	КонецЕсли;
	Если Найти(", Просмотр, Редактирование,", ", " + ДействияВФорме.СвойстваЭлемента + ",") = 0 Тогда
		ДействияВФорме.СвойстваЭлемента = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбъектАвторизацииПриИзмененииНаКлиентеНаСервере(Контекст, Объект)
	
	Если Объект.ОбъектАвторизации = Неопределено Тогда
		Объект.ОбъектАвторизации = Контекст.ТипОбъектовАвторизации;
	КонецЕсли;
	
	Если Контекст.ТекущееПредставлениеОбъектаАвторизации <> Строка(Объект.ОбъектАвторизации) Тогда
		
		Контекст.ТекущееПредставлениеОбъектаАвторизации = Строка(Объект.ОбъектАвторизации);
		
		Если НЕ Контекст.ПользовательИБСуществует И Контекст.ДоступКИнформационнойБазеРазрешен Тогда
			Контекст.ПользовательИнфБазыИмя = ПолучитьКраткоеИмяПользователяИБ(Контекст.ТекущееПредставлениеОбъектаАвторизации);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Чтение, запись, удаление, расчет краткого имени пользователя ИБ, проверка несоответствия

&НаСервере
Процедура ПрочитатьПользователяИБ(ПриКопированииЭлемента = Ложь, ТолькоРоли = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПрочитанныеРоли = Неопределено;
	
	Если ТолькоРоли Тогда
		Пользователи.ПрочитатьПользователяИБ(Объект.ИдентификаторПользователяИБ, , ПрочитанныеРоли);
		ЗаполнитьРоли(ПрочитанныеРоли);
		Возврат;
	КонецЕсли;
	
	Пароль              = "";
	ПодтверждениеПароля = "";
	ПрочитанныеСвойства               = Неопределено;
	СтарыйИдентификаторПользователяИБ = Неопределено;
	ПользовательИБСуществует          = Ложь;
	ДоступКИнформационнойБазеРазрешен = Ложь;
	
	// Заполнение начальных значений свойств пользователяИБ у пользователя.
	Пользователи.ПрочитатьПользователяИБ(Неопределено, ПрочитанныеСвойства, ПрочитанныеРоли);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПрочитанныеСвойства);
	ПользовательИнфБазыАутентификацияСтандартная = Истина;
	
	Если ПриКопированииЭлемента Тогда
		
		Если Пользователи.ПрочитатьПользователяИБ(Параметры.ЗначениеКопирования.ИдентификаторПользователяИБ, ПрочитанныеСвойства, ПрочитанныеРоли) Тогда
			// Т.к. у скопированного пользователя есть связь с пользователемИБ,
			// то устанавливается будущая связь и у нового пользователя.
			ДоступКИнформационнойБазеРазрешен = Истина;
			// Т.к. пользовательИБ скопированного пользователя прочитан,
			// то копируются свойства и роли пользователяИБ.
			ЗаполнитьЗначенияСвойств(ЭтаФорма,
			                         ПрочитанныеСвойства,
			                         "ПользовательИнфБазыАутентификацияOpenID,
			                         |ПользовательИнфБазыАутентификацияСтандартная,
			                         |ПользовательИнфБазыЗапрещеноИзменятьПароль");
		КонецЕсли;
		Объект.ИдентификаторПользователяИБ = Неопределено;
	Иначе
		Если Пользователи.ПрочитатьПользователяИБ(Объект.ИдентификаторПользователяИБ, ПрочитанныеСвойства, ПрочитанныеРоли) Тогда
		
			ПользовательИБСуществует          = Истина;
			ДоступКИнформационнойБазеРазрешен = Истина;
			СтарыйИдентификаторПользователяИБ = Объект.ИдентификаторПользователяИБ;
			
			ЗаполнитьЗначенияСвойств(ЭтаФорма,
			                         ПрочитанныеСвойства,
			                         "ПользовательИнфБазыИмя,
			                         |ПользовательИнфБазыАутентификацияOpenID,
			                         |ПользовательИнфБазыАутентификацияСтандартная,
			                         |ПользовательИнфБазыЗапрещеноИзменятьПароль");
			
			Если ПрочитанныеСвойства.ПользовательИнфБазыПарольУстановлен Тогда
				Пароль              = "**********";
				ПодтверждениеПароля = "**********";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьПредставлениеЯзыка(ПрочитанныеСвойства.ПользовательИнфБазыЯзык);
	ЗаполнитьРоли(ПрочитанныеРоли);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПользователяИБ(ТекущийОбъект, Отказ)
	
	// Восстановление действий в форме, если они изменены на клиенте
	ОпределитьДействияВФорме();
	
	Если НЕ (ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех" ИЛИ
	         ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих"    )Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачальныеСвойства = Неопределено;
	НовыеСвойства     = Неопределено;
	НовыеРоли         = Неопределено;
	
	// Чтение старых свойств/заполнение начальных свойств пользователяИБ у пользователя.
	Пользователи.ПрочитатьПользователяИБ(ТекущийОбъект.ИдентификаторПользователяИБ, НовыеСвойства);
	НовыеСвойства.ПользовательИнфБазыПолноеИмя = Строка(ТекущийОбъект.ОбъектАвторизации);
	
	Пользователи.ПрочитатьПользователяИБ(Неопределено, НачальныеСвойства);
	ЗаполнитьЗначенияСвойств(НовыеСвойства,
	                         НачальныеСвойства,
	                         "ПользовательИнфБазыПоказыватьВСпискеВыбора,
	                         |ПользовательИнфБазыАутентификацияOpenID,
	                         |ПользовательИнфБазыАутентификацияСтандартная,
	                         |ПользовательИнфБазыАутентификацияОС,
	                         |ПользовательИнфБазыОсновнойИнтерфейс,
	                         |ПользовательИнфБазыРежимЗапуска");
	
	Если ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех" Тогда
		ЗаполнитьЗначенияСвойств(НовыеСвойства,
		                         ЭтаФорма,
		                         "ПользовательИнфБазыИмя,
		                         |ПользовательИнфБазыАутентификацияOpenID,
		                         |ПользовательИнфБазыАутентификацияСтандартная,
		                         |ПользовательИнфБазыПароль,
		                         |ПользовательИнфБазыЗапрещеноИзменятьПароль");
	Иначе
		ЗаполнитьЗначенияСвойств(НовыеСвойства,
		                         ЭтаФорма,
		                         "ПользовательИнфБазыИмя,
		                         |ПользовательИнфБазыПароль");
	КонецЕсли;
	
	Если НЕ ПользователиСерверПовтИсп.АутентификацияOpenIDНастраивается() Тогда
		НовыеСвойства.ПользовательИнфБазыАутентификацияСтандартная = Истина;
	КонецЕсли;
	
	НовыеСвойства.ПользовательИнфБазыЯзык = ПолучитьВыбранныйЯзык();
		
	Если ДействияВФорме.Роли = "Редактирование" И Объект.УстановитьРолиНепосредственно Тогда
		НовыеРоли = ПользовательИнфБазыРоли.Выгрузить(, "Роль").ВыгрузитьКолонку("Роль");
	КонецЕсли;
	
	// Попытка записи пользователя ИБ
	ОписаниеОшибки = "";
	Если Пользователи.ЗаписатьПользователяИБ(ТекущийОбъект.ИдентификаторПользователяИБ, НовыеСвойства, НовыеРоли, НЕ ПользовательИБСуществует, ОписаниеОшибки) Тогда
		Если НЕ ПользовательИБСуществует Тогда
			ТекущийОбъект.ИдентификаторПользователяИБ = НовыеСвойства.ПользовательИнфБазыУникальныйИдентификатор;
			ПользовательИБСуществует = Истина;
		КонецЕсли;
	Иначе
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УдалитьПользователяИБ(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОписаниеОшибки = "";
	Если НЕ Пользователи.УдалитьПользователяИБ(СтарыйИдентификаторПользователяИБ, ОписаниеОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки, , , , Отказ);
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьКраткоеИмяПользователяИБ(Знач ПолноеИмя)
	
	КраткоеИмя = "";
	ПервыйПроходЦикла = Истина;
	
	Пока Истина Цикл
		Если НЕ ПервыйПроходЦикла Тогда
			КраткоеИмя = КраткоеИмя + ВРег(Лев(ПолноеИмя, 1));
		КонецЕсли;
		ПозицияПробела = Найти(ПолноеИмя, " ");
		Если ПозицияПробела = 0 Тогда
			Если ПервыйПроходЦикла Тогда
				КраткоеИмя = ПолноеИмя;
			КонецЕсли;
			Прервать;
		КонецЕсли;
		
		Если ПервыйПроходЦикла Тогда
			КраткоеИмя = Лев(ПолноеИмя, ПозицияПробела - 1);
		КонецЕсли;
		
		ПолноеИмя = Прав(ПолноеИмя, СтрДлина(ПолноеИмя) - ПозицияПробела);
		
		ПервыйПроходЦикла = Ложь;
	КонецЦикла;
	
	КраткоеИмя = СтрЗаменить(КраткоеИмя, " ", "");
	
	Возврат КраткоеИмя;
	
КонецФункции

&НаСервере
Процедура ОпределитьНесоответствияПользователяСПользователемИБ(ПараметрыЗаписи = Неопределено)
	
	//** Определение связи с несуществующим пользователем ИБ
	ЕстьНоваяСвязьСНесуществующимПользователемИБ = НЕ ПользовательИБСуществует И ЗначениеЗаполнено(Объект.ИдентификаторПользователяИБ);
	Если ПараметрыЗаписи <> Неопределено
	   И ЕстьСвязьСНесуществующимПользователемИБ
	   И НЕ ЕстьНоваяСвязьСНесуществующимПользователемИБ Тогда
		
		ПараметрыЗаписи.Вставить("ОчищенаСвязьСНесуществущимПользователемИБ", Объект.Ссылка);
	КонецЕсли;
	ЕстьСвязьСНесуществующимПользователемИБ = ЕстьНоваяСвязьСНесуществующимПользователемИБ;
	
	Если ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех" Тогда
		// Связь не может быть изменена
		Элементы.СвязьОбработкаНесоответствия.Видимость = Ложь;
	Иначе
		Элементы.СвязьОбработкаНесоответствия.Видимость = ЕстьСвязьСНесуществующимПользователемИБ;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Начальное заполнение, проверка заполнения, доступность свойств

&НаСервере
Процедура ЗаполнитьПредставлениеЯзыка(Язык)
	
	ПредставлениеЯзыка = "";
	
	Для каждого МетаданныеЯзыка ИЗ Метаданные.Языки Цикл
	
		Если МетаданныеЯзыка.Имя = Язык Тогда
			ПредставлениеЯзыка = МетаданныеЯзыка.Синоним;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВыбранныйЯзык()
	
	Для каждого МетаданныеЯзыка ИЗ Метаданные.Языки Цикл
	
		Если МетаданныеЯзыка.Синоним = ПредставлениеЯзыка Тогда
			Возврат МетаданныеЯзыка.Имя;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРоли(ПрочитанныеРоли)
	
	ПользовательИнфБазыРоли.Очистить();
	
	Для каждого Роль Из ПрочитанныеРоли Цикл
		ПользовательИнфБазыРоли.Добавить().Роль = Роль;
	КонецЦикла;
	
	Если ПоказатьТолькоВыбранныеРоли Тогда
		ОбновитьДеревоРолей();
	Иначе
		ОбновитьПометкуВыбранныхРолей(Роли.ПолучитьЭлементы());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьСвойств()
	
	Элементы.ОбъектАвторизации.ТолькоПросмотр                            = ДействияВФорме.СвойстваЭлемента       <> "Редактирование" ИЛИ
	                                                                       ОбъектАвторизацииЗаданПриОткрытии ИЛИ
	                                                                       ЗначениеЗаполнено(Объект.Ссылка) И
	                                                                           ЗначениеЗаполнено(Объект.ОбъектАвторизации);
	Элементы.ДоступКИнформационнойБазеРазрешен.ТолькоПросмотр            = ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	Элементы.СвойстваПользователяИБ.ТолькоПросмотр                       = ДействияВФорме.СвойстваПользователяИБ =  "ПросмотрВсех";
	Элементы.Пароль.ТолькоПросмотр                                       = ПользовательИнфБазыЗапрещеноИзменятьПароль И НЕ АвторизованПолноправныйПользователь;
	Элементы.ПодтверждениеПароля.ТолькоПросмотр                          = ПользовательИнфБазыЗапрещеноИзменятьПароль И НЕ АвторизованПолноправныйПользователь;
	Элементы.ПользовательИнфБазыИмя.ТолькоПросмотр                       = ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	Элементы.ПользовательИнфБазыЗапрещеноИзменятьПароль.ТолькоПросмотр   = ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	УстановитьТолькоПросмотрРолей(ЗапретРедактированияРолей ИЛИ ДействияВФорме.Роли <> "Редактирование" ИЛИ НЕ Объект.УстановитьРолиНепосредственно);
	
	Элементы.ОсновныеСвойства.Доступность                     = ДоступКИнформационнойБазеРазрешен;
	Элементы.РедактированиеИлиПросмотрРолей.Доступность       = ДоступКИнформационнойБазеРазрешен;
	Элементы.ПользовательИнфБазыИмя.АвтоОтметкаНезаполненного = ДоступКИнформационнойБазеРазрешен;
	
	Элементы.Пароль.Доступность                                     = ПользовательИнфБазыАутентификацияСтандартная;
	Элементы.ПодтверждениеПароля.Доступность                        = ПользовательИнфБазыАутентификацияСтандартная;
	Элементы.ПользовательИнфБазыЗапрещеноИзменятьПароль.Доступность = ПользовательИнфБазыАутентификацияСтандартная;
	
	Элементы.ДоступКИнформационнойБазеРазрешен.Доступность = Не Объект.Недействителен;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаСервере
Функция КоллекцияРолей(ТаблицаЗначенийДляЧтения = Ложь)
	
	Если ТаблицаЗначенийДляЧтения Тогда
		Возврат РеквизитФормыВЗначение("ПользовательИнфБазыРоли");
	КонецЕсли;
	
	Возврат ПользовательИнфБазыРоли;
	
КонецФункции

&НаКлиенте
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
	
	ТипПользователя = Перечисления.ТипыПользователей.ВнешнийПользователь;
	ДеревоРолей = ПользователиСерверПовтИсп.ДеревоРолей(ПоказатьПодсистемыРолей, ТипПользователя).Скопировать();
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

&НаКлиенте
Процедура НедействителенПриИзменении(Элемент)
	
	Если Объект.Недействителен Тогда
		ДоступКИнформационнойБазеРазрешен = Ложь;
	КонецЕсли;	
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры
