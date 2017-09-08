﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Запретим создание новых
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Взаимодействия.УстановитьЗаголовокФормыЭлектронногоПисьма(ЭтаФорма);
	
	// Заполним список выбора для поля РассмотретьПосле
	Взаимодействия.ЗаполнитьСписокВыбораДляРассмотретьПосле(Элементы.РассмотретьПосле.СписокВыбора);
	Если Объект.Рассмотрено Тогда
		Элементы.РассмотретьПосле.Доступность = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, Объект, "СтраницаДополнительныеРеквизиты");
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Объект.Ссылка.Пустая() Тогда
		Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначения.ПолучитьКартинкуКомментария(Объект.Комментарий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Предмет = Взаимодействия.ПолучитьЗначениеПредмета(Объект.Ссылка);
	
	Вложения.Очистить();
	ТаблицаВложения = УправлениеЭлектроннойПочтой.ПолучитьВложенияЭлектронногоПисьма(Объект.Ссылка, Истина);
	
	Если ТаблицаВложения.Количество() > 0 Тогда
		
		НайденныеСтроки = ТаблицаВложения.НайтиСтроки(Новый Структура("ИДФайлаЭлектронногоПисьма", ""));
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НайденныеСтроки, Вложения);
		
	КонецЕсли;
	
	Для Каждого УдаленноеВложение Из ТекущийОбъект.НепринятыеВложения Цикл
		
		НовоеВложение = Вложения.Добавить();
		НовоеВложение.ИмяФайла = УдаленноеВложение.ИмяВложение;
		НовоеВложение.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(".msg") + 1;
		
	КонецЦикла;
	
	Если Вложения.Количество() = 0 Тогда
		
		Элементы.Вложения.Видимость = Ложь;
		
	КонецЕсли;
	
	// Установим текст и вид текста
	Если Объект.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML Тогда
		ТекстПисьма = Взаимодействия.ОбработатьТекстHTML(Объект.Ссылка);
		Элементы.ТекстПисьма.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		Элементы.ТекстПисьма.ТолькоПросмотр = Ложь;
	Иначе
		ТекстПисьма = Объект.Текст;
		Элементы.ТекстПисьма.Вид = ВидПоляФормы.ПолеТекстовогоДокумента;
	КонецЕсли;
	
	// Сформируем представление отправителя
	ОтправительПредставление = ВзаимодействияКлиентСервер.ПолучитьПредставлениеАдресата(
		Объект.ОтправительПредставление, Объект.ОтправительАдрес,"");
	
	// Сформируем представление Кому и Копии
	ПолучателиПредставление =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиПисьма, Ложь);
	ПолучателиКопийПредставление =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиКопий, Ложь);
	ПолучателиОтветаПредставление = 
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиОтвета, Ложь);

	ЗаполнитьДополнительнуюИнформацию();
	
	ОбработатьНеобходимостьУведомленияОПрочтении();
	
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтаФорма, "ЭлектронноеПисьмоВходящее");
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначения.ПолучитьКартинкуКомментария(Объект.Комментарий);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ВзаимодействияКлиент.ОтработатьОповещение(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, РежимЗаписи, РежимПроведения)
	
	Если Объект.Рассмотрено И ТребуетсяУстановкаФлагаОтправкиУведомления Тогда
		УправлениеЭлектроннойПочтой.УстановитьПризнакОтправкиУведомления(Объект.Ссылка, Истина);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Взаимодействия.ПриЗаписиВзаимодействияИзФормы(ТекущийОбъект, Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Рассмотрено И ТребуетсяЗапросУведомленияОПрочтении Тогда
		
		Результат = Вопрос(НСтр("ru='Отправитель запросил уведомление о прочтении. Отправить?'"),
		РежимДиалогаВопрос.ДаНет,
		,
		КодВозвратаДиалога.Да,
		НСтр("ru='Запрос уведомления'"));
		
		Если Результат = КодВозвратаДиалога.Да Тогда
			УправлениеЭлектроннойПочтой.УстановитьПризнакОтправкиУведомления(Объект.Ссылка, Истина);
		ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
			УправлениеЭлектроннойПочтой.УстановитьПризнакОтправкиУведомления(Объект.Ссылка, Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначения.ПолучитьКартинкуКомментария(Объект.Комментарий);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РассмотретьПослеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ОбработатьВыборВПолеРассмотретьПосле(Объект.РассмотретьПосле,
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура РассмотреноПриИзменении(Элемент)
	
	Элементы.РассмотретьПосле.Доступность = НЕ Объект.Рассмотрено;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПолучателей()
	
	// Получим список адресатов
	масОтправитель = Новый Массив;
	масОтправитель.Добавить(Новый Структура("Адрес,Представление,Контакт",
		Объект.ОтправительАдрес,
		Объект.ОтправительПредставление, 
		Объект.ОтправительКонтакт));
	
	спсПолучатели = Новый СписокЗначений;
	спсПолучатели.Добавить(масОтправитель, "Отправитель");
	спсПолучатели.Добавить(
		УправлениеЭлектроннойПочтойКлиент.ТаблицуКонтактовВМассив(Объект.ПолучателиПисьма), "Получатели");
	спсПолучатели.Добавить(
		УправлениеЭлектроннойПочтойКлиент.ТаблицуКонтактовВМассив(Объект.ПолучателиКопий),  "Копии");
	спсПолучатели.Добавить(
		УправлениеЭлектроннойПочтойКлиент.ТаблицуКонтактовВМассив(Объект.ПолучателиОтвета), "Ответ");
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("УчетнаяЗапись", Объект.УчетнаяЗапись);
	ПараметрыОткрытия.Вставить("СписокВыбранных", спсПолучатели);
	ПараметрыОткрытия.Вставить("Предмет", Предмет);
	ПараметрыОткрытия.Вставить("Письмо", Объект.Ссылка);
	
	// Откроем форму для редактирования списка адресатов
	Результат = ОткрытьФормуМодально("ОбщаяФорма.УточнениеКонтактов", ПараметрыОткрытия);
	Если ТипЗнч(Результат) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьУточненныеКонтакты(Результат);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУточненныеКонтакты(Результат)
	
	Объект.ПолучателиКопий.Очистить();
	Объект.ПолучателиОтвета.Очистить();
	Объект.ПолучателиПисьма.Очистить();
	
	Для каждого ЭлементМассива Из Результат Цикл
	
		Если ЭлементМассива.Группа = "Получатели" Тогда
			ТаблицаПолучателей = Объект.ПолучателиПисьма;
		ИначеЕсли ЭлементМассива.Группа = "Копии" Тогда
			ТаблицаПолучателей = Объект.ПолучателиКопий;
		ИначеЕсли ЭлементМассива.Группа = "Ответ" Тогда
			ТаблицаПолучателей = Объект.ПолучателиОтвета;
		ИначеЕсли ЭлементМассива.Группа = "Отправитель" Тогда
			Объект.ОтправительАдрес = ЭлементМассива.Адрес;
			Объект.ОтправительКонтакт = ЭлементМассива.Контакт;
			Продолжить;
		Иначе
			Продолжить;
		КонецЕсли;
		
		СтрокаПолучатели = ТаблицаПолучателей.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПолучатели,ЭлементМассива);
	
	КонецЦикла;
	
	// Сформируем представление отправителя
	ОтправительПредставление = ВзаимодействияКлиентСервер.ПолучитьПредставлениеАдресата(
		Объект.ОтправительПредставление, Объект.ОтправительАдрес, "");
	
	// Сформируем представление Кому и Копии
	ПолучателиПредставление       =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиПисьма, Ложь);
	ПолучателиКопийПредставление  =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиКопий, Ложь);
	ПолучателиОтветаПредставление = 
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиОтвета, Ложь);
	
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтаФорма, "ЭлектронноеПисьмоВходящее");

КонецПроцедуры

&НаКлиенте
Процедура ОтправительПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.ОтправительКонтакт) Тогда
		ОткрытьЗначение(Объект.ОтправительКонтакт);
	Иначе
		РедактироватьПолучателей();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПисьмаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Вложения

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВложениеСуществует = ЗначениеЗаполнено(ТекущиеДанные.Ссылка);
	Элементы.ВложенияКонтекстноеМенюСвойстваВложения.Доступность = ВложениеСуществует;
	Элементы.ОткрытьВложение.Доступность = ВложениеСуществует;
	Элементы.СохранитьВложение.Доступность = ВложениеСуществует;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьВложениеВыполнить()
	
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВложениеВыполнить()
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеФайла = ПрисоединенныеФайлы.ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
		ПрисоединенныеФайлыКлиент.СохранитьФайлКак(ДанныеФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УточнитьКонтакты(Команда)
	
	РедактироватьПолучателей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПисьма(Команда)
	
	ТекстЗаголовкиИнтернета = Новый ТекстовыйДокумент;
	ТекстЗаголовкиИнтернета.ДобавитьСтроку(Объект.ВнутреннийЗаголовок);
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Создано", Объект.Дата);
	СтруктураПараметры.Вставить("Получено", Объект.ДатаПолучения);
	СтруктураПараметры.Вставить("УведомитьОДоставке", Объект.УведомитьОДоставке);
	СтруктураПараметры.Вставить("УведомитьОПрочтении", Объект.УведомитьОПрочтении);
	СтруктураПараметры.Вставить("ЗаголовкиИнтернета", ТекстЗаголовкиИнтернета);
	СтруктураПараметры.Вставить("Письмо", Объект.Ссылка);
	СтруктураПараметры.Вставить("ТипПисьма", "ЭлектронноеПисьмоВходящее");
	СтруктураПараметры.Вставить("Кодировка", Объект.Кодировка);
	СтруктураПараметры.Вставить("ВнутреннийНомер", Объект.Номер);
	СтруктураПараметры.Вставить("УчетнаяЗапись", Объект.УчетнаяЗапись);
	
	ОткрытьФормуМодально("ЖурналДокументов.Взаимодействия.Форма.ПараметрыЭлектронногоПисьма",
		СтруктураПараметры, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеВзаимодействияВыполнить()
	
	ОткрытьФормуМодально("ЖурналДокументов.Взаимодействия.ФормаСписка",
		Новый Структура("ОбъектОтбора", Объект.Предмет));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКодировку(Команда)
	
	СписокКодировок = УправлениеЭлектроннойПочтой.ПолучитьСписокКодировок();
	ВыбраннаяКодировка = СписокКодировок.ВыбратьЭлемент("Выберите кодировку", 
		СписокКодировок.НайтиПоЗначению(НРег(Объект.Кодировка)));
	Если ВыбраннаяКодировка <> Неопределено Тогда
		ПреобразоватьКодировкуПисьма(ВыбраннаяКодировка.Значение);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СвойстваВложения(Команда)
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ПрисоединенныйФайл, ТолькоПросмотр", ТекущиеДанные.Ссылка,Истина);
	ОткрытьФорму("ОбщаяФорма.ПрисоединенныйФайл", ПараметрыФормы,, ТекущиеДанные.Ссылка);
	
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
Процедура ОткрытьВложение()
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Возврат;
		КонецЕсли;
		УправлениеЭлектроннойПочтойКлиент.ОткрытьВложение(ТекущиеДанные.Ссылка,УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПреобразоватьКодировкуПисьма(ВыбраннаяКодировка)
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайла, Объект.Кодировка);
	ЗаписьТекста.Записать(
		?(Объект.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML, Объект.ТекстHTML, Объект.Текст));
	ЗаписьТекста.Закрыть();
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяВременногоФайла, ВыбраннаяКодировка);
	Если Объект.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML Тогда
		Объект.ТекстHTML = ЧтениеТекста.Прочитать();
		ТекстПисьма = Объект.ТекстHTML;
	Иначе
		Объект.Текст = ЧтениеТекста.Прочитать();
		ТекстПисьма = Объект.Текст;
	КонецЕсли;
	ЧтениеТекста.Закрыть();
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайла, Объект.Кодировка);
	ЗаписьТекста.ЗаписатьСтроку(ОтправительПредставление);
	ЗаписьТекста.ЗаписатьСтроку(ПолучателиКопийПредставление);
	ЗаписьТекста.ЗаписатьСтроку(ПолучателиОтветаПредставление);
	ЗаписьТекста.ЗаписатьСтроку(ПолучателиПредставление);
	ЗаписьТекста.ЗаписатьСтроку(Объект.Тема);
	ЗаписьТекста.Закрыть();
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяВременногоФайла, ВыбраннаяКодировка);
	ОтправительПредставление = ЧтениеТекста.ПрочитатьСтроку();
	ПолучателиКопийПредставление = ЧтениеТекста.ПрочитатьСтроку();
	ПолучателиОтветаПредставление = ЧтениеТекста.ПрочитатьСтроку();
	ПолучателиПредставление = ЧтениеТекста.ПрочитатьСтроку();
	Объект.Тема = ЧтениеТекста.ПрочитатьСтроку();
	ЧтениеТекста.Закрыть();
	
	Объект.Кодировка = ВыбраннаяКодировка;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДополнительнуюИнформацию()
	
	ДополнительнаяИнформацияОПисьме = НСтр("ru = 'Создано:'") + "   " + Объект.Дата + НСтр("ru = '
	|Получено:'") + "  " + Объект.ДатаПолучения + НСтр("ru = '
	|Важность:'") + "  " + Объект.Важность + НСтр("ru = '
	|Кодировка:'") + " " + Объект.Кодировка;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьНеобходимостьУведомленияОПрочтении()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УведомленияОПрочтении.Письмо
	|ИЗ
	|	РегистрСведений.УведомленияОПрочтении КАК УведомленияОПрочтении
	|ГДЕ
	|	УведомленияОПрочтении.Письмо = &Письмо
	|	И (НЕ УведомленияОПрочтении.ТребуетсяОтправка)";
	
	Запрос.УстановитьПараметр("Письмо",Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НеобходимоеДействие = Взаимодействия.ПолучитьПараметрыРаботыПользователяДляВходящегоЭлектронногоПисьма();
	
	Если НеобходимоеДействие = Перечисления.ПорядокОтветовНаЗапросыУведомленийОПрочтении.ВсегдаОтправлятьУведомление Тогда
		
		ТребуетсяУстановкаФлагаОтправкиУведомления = Истина;
		
	ИначеЕсли НеобходимоеДействие = 
		Перечисления.ПорядокОтветовНаЗапросыУведомленийОПрочтении.НикогдаНеОтправлятьУведомление Тогда
		
		УправлениеЭлектроннойПочтой.УстановитьПризнакОтправкиУведомления(Объект.Ссылка,Ложь);
		
	ИначеЕсли НеобходимоеДействие = 
		Перечисления.ПорядокОтветовНаЗапросыУведомленийОПрочтении.ЗапрашиватьПередТемКакОтправитьУведомление Тогда
		
		ТребуетсяЗапросУведомленияОПрочтении = Истина;
		
	КонецЕсли;
	
КонецПроцедуры