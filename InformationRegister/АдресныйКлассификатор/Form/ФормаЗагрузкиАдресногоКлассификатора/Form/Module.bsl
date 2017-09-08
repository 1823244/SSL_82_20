﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресныеОбъектыПереданные = ?(Параметры.Свойство("АдресныеОбъекты"), Параметры.АдресныеОбъекты, Неопределено);
	
	ЗаполнитьТаблицуАдресныхОбъектов(АдресныеОбъектыПереданные);
	
	ИсточникДанныхДляЗагрузки = 0;
	ПутьКФайламДанныхНаДиске = "";
	ДискИТС = "";
	
	Если АдресныеОбъектыПереданные = Неопределено Тогда
		ЗагрузитьСохраненныеПараметрыЗагрузки();
	Иначе
		ИсточникДанныхДляЗагрузки = 1;
	КонецЕсли;
	
	ОшибкаЗагрузкиДляОС = ПроверитьОшибкуЗагрузкиДляОС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		Предупреждение(НСтр("ru = 'Классификатор не может быть загружен в Веб клиенте.'"),, НСтр("ru = 'Загрузка адресного классификатора.'"));
		Закрыть();
	#КонецЕсли
	
	Если ОшибкаЗагрузкиДляОС Тогда 
		Предупреждение(НСтр("ru = 'Загрузка КЛАДР на сервере под управлением Linux/x86-64 не доступна.'"),, НСтр("ru = 'Загрузка адресного классификатора.'"));
		Закрыть();
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если ИдентификаторЗадания <> Неопределено Тогда 
		ДлительныеОперацииКлиент.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЕсли;	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// Обработчик события НачалоВыбора поля ввода формы ПутьКФайламДанныхНаДиске.
// Вызывает диалог выбора  директории, после выбора проверяет, существуют
// ли в выбранной директории файлы данных.
//
&НаКлиенте
Процедура ПутьКФайламДанныхНаДискеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
#Если Не ВебКлиент Тогда
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выбор каталога с файлами данных'");
	ДиалогОткрытияФайла.Каталог = Элементы.ПутьКФайламДанныхНаДиске.ТекстРедактирования;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ПутьКФайламДанныхНаДиске = ДиалогОткрытияФайла.Каталог;
		
		ОчиститьСообщения();
		
		Если АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловДанныхВКаталоге(ПутьКФайламДанныхНаДиске) Тогда
			УстановитьИзмененияВИнтерфейсе ();
		Иначе
			СообщениеПользователю = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Файлы данных не найдены в каталоге ""%1"".'"),
										ПутьКФайламДанныхНаДиске);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ПутьКФайламДанныхНаДиске");
		КонецЕсли;
	КонецЕсли;
#Иначе
	Предупреждение(НСтр("ru = 'Функциональность не поддерживается на веб клиенте.'"));
#КонецЕсли
	
КонецПроцедуры

// Обработчик события НачалоВыбора поля ввода формы ДискИТС.
// Вызывает диалог выбора директории, после выбора проверяет, существуют
// ли в выбранной директории файлы архивов данных.
//
&НаКлиенте
Процедура ДискИТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
#Если Не ВебКлиент Тогда
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.Заголовок = "Выбор пути к диску ИТС";
	ДиалогОткрытияФайла.Каталог = ДискИТС;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ДискИТС = ДиалогОткрытияФайла.Каталог;
		
		ФайлыСуществуют = АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловНаДискеИТС(ДискИТС);
		
		ОчиститьСообщения();
		
		Если ФайлыСуществуют Тогда
			УстановитьИзмененияВИнтерфейсе();
		Иначе
			СообщениеПользователю = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Файлы данных КЛАДР не найдены: ""%1"".
										|Проверьте правильность указанного пути к Диску ИТС.'"),
							ДискИТС);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ДискИТС");
		КонецЕсли;
	КонецЕсли;
#Иначе
	Предупреждение(НСтр("ru = 'Функциональность не поддерживается на веб клиенте.'"));
#КонецЕсли
	
КонецПроцедуры

// Обработчик события выбора поля таблицы "ЭлементАдресныйОбъект"
// Изменяет статус загрузки адресного объекта поля на противоположный
//
&НаКлиенте
Процедура ТаблицаАдресныхОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Элемент.ТекущиеДанные.Пометка = НЕ Элемент.ТекущиеДанные.Пометка;
	
	ОтметитьОбязательные(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаАдресныхОбъектовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОтметитьОбязательные(ЭтаФорма);
	
КонецПроцедуры

// Обработчик события ПриИзменении поля переключателя ИсточникДанныхДляЗагрузки
// Устанавливает параметры видимости элементов (параметров вида загрузки) 
// в зависимости от значения переключателя.
//
&НаКлиенте
Процедура СпособЗагрузкиПриИзменении(Элемент)
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Обработчик нажатия на "кнопку "ВыделитьВсе"
// командной панели элемента управления "АдресныеОбъектыДляЗагрузки"
// Выделяет все адресные объекты в списке адресных объектов для загрузки
//
&НаКлиенте
Процедура ВыделитьВсеВыполнить()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		ЭлементАдресныйОбъект.Пометка = Истина;
	КонецЦикла;
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

// Обработчик нажатия на "кнопку "ОтменитьВыделитьВсе"
// командной панели элемента управления "АдресныеОбъектыДляЗагрузки"
// Снимает выделение со всех адресных объектов в списке
// адресных объектов для загрузки
//
&НаКлиенте
Процедура ОтменитьВыделитьВсеВыполнить()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		ЭлементАдресныйОбъект.Пометка = Ложь;
	КонецЦикла;
	
	ОтметитьОбязательные(ЭтаФорма);
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВыполнить()
	
	ОчиститьСообщения();
	
	УстановитьДоступностьКнопокПриЗагрузке(Ложь);
	
	ЗагрузитьКЛАДР();
	
КонецПроцедуры

// Обработчик нажатия на кнопку "Далее"
//
&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ОчиститьСообщения();
	
	Если      Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборАдресныхОбъектов Тогда
		Если КоличествоОтмеченныхАдресныхОбъектов() = 0 Тогда
			СообщениеПользователю = НСтр("ru = 'Требуется выбрать хотя бы один адресный объект.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "АдресныеОбъектыДляЗагрузки");
			Возврат;
		КонецЕсли;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника Тогда
		Если ИсточникДанныхДляЗагрузки = 2
			И (ПустаяСтрока(ДискИТС)
				ИЛИ НЕ АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловНаДискеИТС(ДискИТС))Тогда
					СообщениеПользователю = НСтр("ru = 'Проверьте правильность указания пути к диску ИТС.'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ДискИТС");
			Возврат;
		ИначеЕсли  ИсточникДанныхДляЗагрузки = 3
			И (ПустаяСтрока(ПутьКФайламДанныхНаДиске)
				ИЛИ НЕ АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловДанныхВКаталоге(ПутьКФайламДанныхНаДиске))Тогда
					СообщениеПользователю = НСтр("ru = 'Проверьте правильность указания пути к файлам КЛАДР, а так же состав файлов.'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ПутьКФайламДанныхНаДиске");
			Возврат;
		КонецЕсли;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка;
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

// Обработчик нажатия на кнопку "Назад"
//
&НаКлиенте
Процедура КомандаНазад(Команда)
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборАдресныхОбъектов;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПроверитьОшибкуЗагрузкиДляОС()
	
	ИнформацияОСервере = Новый СистемнаяИнформация;
	Если ИнформацияОСервере.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда 
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьКнопокПриЗагрузке(Флаг = Истина)
	
	Элементы.Назад.Доступность		= Флаг;
	Элементы.Загрузить.Доступность	= Флаг;

КонецПроцедуры	

&НаСервере
Процедура СохранитьПараметрыЗагрузки()
	
	МассивЗагружаемыхАО = Новый Массив;
	
	Для Каждого ЭлементАО Из АдресныеОбъектыДляЗагрузки Цикл
		Если ЭлементАО.Пометка Тогда
			МассивЗагружаемыхАО.Добавить(Лев(ЭлементАО.НаименованиеАдресногоОбъекта, 2));
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ПараметрыЗагрузкиАдресногоКлассификатора", 
		"ЗагружаемыеРегионы", 
		МассивЗагружаемыхАО
	);
	
	ИсточникКЛАДР = Новый Структура("ИсточникДанныхДляЗагрузки");
	ИсточникКЛАДР.ИсточникДанныхДляЗагрузки = ИсточникДанныхДляЗагрузки;
	
	Если      ИсточникДанныхДляЗагрузки = 2 Тогда
		ИсточникКЛАДР.Вставить("ДискИТС", ДискИТС);
	ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
		ИсточникКЛАДР.Вставить("ПутьКФайламДанныхНаДиске", ПутьКФайламДанныхНаДиске);
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ПараметрыЗагрузкиАдресногоКлассификатора", 
		"ИсточникКЛАДР", 
		ИсточникКЛАДР
	);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСохраненныеПараметрыЗагрузки()
	
	ИсточникКЛАДР = ЗагрузитьНастройкуЗагрузкиКЛАДР("ИсточникКЛАДР");
	
	Если ИсточникКЛАДР <> Неопределено Тогда
		ИсточникДанныхДляЗагрузки = ИсточникКЛАДР.ИсточникДанныхДляЗагрузки;
		Если ИсточникДанныхДляЗагрузки = 2 Тогда
			ДискИТС = ИсточникКЛАДР.ДискИТС;
		ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
			ПутьКФайламДанныхНаДиске = ИсточникКЛАДР.ПутьКФайламДанныхНаДиске;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Получает значение из системного хранилища настроек ИБ
//
&НаСервереБезКонтекста
Функция ЗагрузитьНастройкуЗагрузкиКЛАДР(КлючНастроек)
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПараметрыЗагрузкиАдресногоКлассификатора", КлючНастроек);
	
КонецФункции

// Устанавливает текст статус загрузки
//
&НаКлиенте
Процедура УстановитьСтатусЗагрузки(знач Сообщение = "")
	
	СтатусЗагрузки = Сообщение;
	
	Если ПустаяСтрока(Сообщение) Тогда
		Элементы.СтраницыЗагрузки.ТекущаяСтраница = Элементы.ГруппаПустаяГруппа;
	Иначе
		Элементы.СтраницыЗагрузки.ТекущаяСтраница = Элементы.СтраницаСтатусЗагрузки;
	КонецЕсли;
	
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКЛАДР()
	
	// Требуется для аутентификации на пользовательском сайте
	Перем ЗапросФормыАутентификации, ДанныеАутентификации, ПутьКДанным;
	
	ТекстСообщенияОшибки = НСтр("ru = 'Ошибка при загрузке адресных сведений: '");
	
	РезультатВыполнения = Истина;
	
	Если ИсточникДанныхДляЗагрузки = 2 Тогда // загрузка с диска ИТС
		Если Прав(ДискИТС, 1) <> "\" Тогда
			ДискИТС = ДискИТС + "\";
		КонецЕсли;
	ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда // загрузка из файлов на диске
		Если Прав(ПутьКФайламДанныхНаДиске, 1) <> "\" Тогда
			ПутьКФайламДанныхНаДиске = ПутьКФайламДанныхНаДиске + "\";
		КонецЕсли;
	КонецЕсли;
	
	// Подготавливаем массив адресных объектов для загрузки
	АдресныеОбъекты = Новый Массив;
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		Если ЭлементАдресныйОбъект.Пометка Тогда
			АдресныеОбъекты.Добавить(Лев(ЭлементАдресныйОбъект.НаименованиеАдресногоОбъекта, 2));
		КонецЕсли;
	КонецЦикла;
	
	Если АдресныеОбъекты.Найти("SO") = Неопределено Тогда
		АдресныеОбъекты.Добавить("SO");
	КонецЕсли;
	
	// Первый этап - загрузка адаптированной базы данных КЛАДР на клиент.
	// В зависимости от выбора метода загрузка осуществляется по разному.
	Попытка
		ВерсияЗагружаемогоКЛАДР = Неопределено;
		РезультатВыполнения = ЗагрузитьФайлыКЛАДРНаКлиент(ДанныеАутентификации, ЗапросФормыАутентификации, АдресныеОбъекты, ПутьКДанным, ВерсияЗагружаемогоКЛАДР);
		Если Не РезультатВыполнения Тогда 
			Возврат;
		КонецЕсли;	
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОшибки + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияКлиентСервер.УдалитьКаталогСФайлами(ПутьКДанным);
		Возврат;
	КонецПопытки;
	
    // Второй этап - передача файлов на сервер 1С:Предприятия
	Попытка
		ПутьКДаннымНаСервере = Неопределено;
		ПередачаФайловКЛАДРСКлиентаНаСервер(ПутьКДанным, ПутьКДаннымНаСервере, АдресныеОбъекты);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОшибки + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ОбщегоНазначенияКлиентСервер.УдалитьКаталогСФайлами(ПутьКДанным);
		УдалитьФайлыНаСервере(ПутьКДаннымНаСервере);
		Возврат;
	КонецПопытки;

	// Третий этап - загрузка адресных сведений в регистр сведений.
	// Предполагается что к текущему моменту на сервере в каталоге ПутьКДаннымНаСервере
	// содержатся все необходимые файлы данных

	УстановитьСтатусЗагрузки(НСтр("ru = 'Загружаются данные по адресным объектам.'"));
	
	СообщениеОбОшибке = "";
	Результат = ЗагрузкаАдресныхСведенийНаСервере(АдресныеОбъекты, ПутьКДанным, ПутьКДаннымНаСервере, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки);
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	Иначе
		ОбновитьСодержание(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
			Если ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				Результат = Новый Структура;
				Результат.Вставить("РезультатЗагрузки", ПолучитьИзВременногоХранилища(АдресХранилища));
				ОбновитьСодержание(Результат);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры	

&НаКлиенте
Процедура ОбновитьСодержание(Результат)
	
	УстановитьДоступностьКнопокПриЗагрузке();
	
	ОбщегоНазначенияКлиентСервер.УдалитьКаталогСФайлами(Результат.РезультатЗагрузки.ПутьКДанным);
	УдалитьФайлыНаСервере(Результат.РезультатЗагрузки.ПутьКДаннымНаСервере);
	
	Если Результат.РезультатЗагрузки.СтатусВыполнения Тогда 
		Состояние(НСтр("ru = 'Адресный классификатор успешно загружен.'"));
		Оповестить("Запись_АдресныйКлассификатор", Новый Структура("Событие", "Загрузить"));
		СохранитьПараметрыЗагрузки();
		Закрыть(Истина);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Результат.РезультатЗагрузки.СообщениеПользователю) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.РезультатЗагрузки.СообщениеПользователю);
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Функция ЗагрузитьФайлыКЛАДРНаКлиент(ДанныеАутентификации, ЗапросФормыАутентификации, АдресныеОбъекты, ПутьКДанным, ВерсияЗагружаемогоКЛАДР)
	
	Если ИсточникДанныхДляЗагрузки = 1 Тогда
		// Загрузка с пользовательского сайта 1С
		Если Не ПолучитьДанныеАутентификации(ДанныеАутентификации, ЗапросФормыАутентификации) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Состояние(НСтр("ru = 'Загружается адресный классификатор...'"));
		
		Результат = ЗагрузитьАдресныеОбъектыССервера(АдресныеОбъекты, ДанныеАутентификации, ПутьКДанным);
		Если Не Результат.Статус И Не ЗапросФормыАутентификации Тогда
			Если Не ПолучитьДанныеАутентификации(ДанныеАутентификации, ЗапросФормыАутентификации, Истина) Тогда
				Возврат Ложь;
			КонецЕсли;
			Результат = ЗагрузитьАдресныеОбъектыССервера(АдресныеОбъекты, ДанныеАутентификации, ПутьКДанным);
		КонецЕсли;
		
		Если Не Результат.Статус Тогда
			ВызватьИсключение Результат.СообщениеОбОшибке;
		КонецЕсли;
		
		Если Прав(ПутьКДанным, 1) <> "\" Тогда
			ПутьКДанным = ПутьКДанным + "\";
		КонецЕсли;
		
	Иначе
		Если ИсточникДанныхДляЗагрузки = 2 Тогда
			 // Загрузка с диска ИТС
			Состояние(НСтр("ru = 'Загружается адресный классификатор...'"));
			УстановитьСтатусЗагрузки(НСтр("ru = 'Приведение файлов с диска ИТС к требуемому формату.'"));
			ПутьКДанным = АдресныйКлассификаторКлиент.ПреобразоватьФайлыКЛАДРEXEВZIP(ДискИТС);
			Если ПутьКДанным = Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Загрузка адресного классификатора была отменена.'"));
				Возврат Ложь;
			КонецЕсли;
			//
		ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
			// Загрузка из файлов на диске
			Состояние(НСтр("ru = 'Загружается адресный классификатор...'"));
			УстановитьСтатусЗагрузки(НСтр("ru = 'Сжатие файлов.'"));
			МассивФайловДляЗагрузки = АдресныйКлассификаторКлиент.СписокФайловДанных();
			Для Каждого ИмяФайла Из МассивФайловДляЗагрузки Цикл
				АдресныйКлассификаторКлиент.СжатьФайл(ПутьКФайламДанныхНаДиске, ИмяФайла, ПутьКДанным);
			КонецЦикла;
		КонецЕсли;
		
		ZipФайл 				= Новый ЧтениеZipФайла(ПутьКДанным + "kladr.zip");
		ВерсияЗагружаемогоКЛАДР = НачалоДня(ZipФайл.Элементы[0].ВремяИзменения);
		
	КонецЕсли;
	
	ОбновитьОтображениеДанных();
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПередачаФайловКЛАДРСКлиентаНаСервер(ПутьКДанным, ПутьКДаннымНаСервере, АдресныеОбъекты)
	
	УстановитьСтатусЗагрузки(НСтр("ru = 'Передача файлов на сервер 1С:Предприятия.'"));
	
	Если ИсточникДанныхДляЗагрузки = 1 Тогда
		//
		Для Каждого АдресныйОбъект Из АдресныеОбъекты Цикл
			//
			Если АдресныйОбъект = "SO" Тогда
				АдресныйКлассификаторКлиент.ПередатьФайлНаСервер(ПутьКДанным, "socrbase.zip", ПутьКДаннымНаСервере);
			Иначе
				АдресныйКлассификаторКлиент.ПередатьФайлыНаСерверПоАдреснымОбъектам(ПутьКДанным, ПутьКДаннымНаСервере, АдресныйОбъект);
			КонецЕсли;
		КонецЦикла;
	Иначе
		МассивФайловДляЗагрузки = АдресныйКлассификаторКлиент.СписокФайловДанных();
		Для Каждого ИмяФайла Из МассивФайловДляЗагрузки Цикл
			АдресныйКлассификаторКлиент.ПередатьФайлНаСервер(ПутьКДанным, ИмяФайла, ПутьКДаннымНаСервере);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузкаАдресныхСведенийНаСервере(АдресныеОбъекты, ПутьКДанным, ПутьКДаннымНаСервере, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки)
	
	ПараметрыЗагрузки = Новый Структура("АдресныеОбъекты, ПутьКДанным, ПутьКДаннымНаСервере, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки", 
											АдресныеОбъекты, ПутьКДанным, ПутьКДаннымНаСервере, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки);
											
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда 
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		АдресныйКлассификатор.ЗагрузкаАдресныхСведенийИзФайловКЛАДРВРегистрСведений(ПараметрыЗагрузки, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);		
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Загрузка адресного классификатора'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"АдресныйКлассификатор.ЗагрузкаАдресныхСведенийИзФайловКЛАДРВРегистрСведений", 
			ПараметрыЗагрузки, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;	
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		Результат.Вставить("РезультатЗагрузки", ПолучитьИзВременногоХранилища(АдресХранилища));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьФайлыНаСервере(Путь)
	
	ОбщегоНазначенияКлиентСервер.УдалитьКаталогСФайлами(Путь);
	
КонецПроцедуры
                      
&НаКлиенте
Функция ПолучитьДанныеАутентификации(ДанныеАутентификации, ЗапросФормыАутентификации, знач ЗапросКПользователю = Ложь)
	
	Перем КодПользователя, Пароль;
	
	ЗапросФормыАутентификации = Ложь;
	
	Если ЗапросКПользователю Или Не АдресныйКлассификатор.ПолучитьПараметрыАутентификации(КодПользователя, Пароль) Тогда
		ЗапросФормыАутентификации = Истина;
		УстановитьСтатусЗагрузки(НСтр("ru = 'Аутентификация на пользовательском сайте 1С.'"));
		Результат = ОткрытьФормуМодально("РегистрСведений.АдресныйКлассификатор.Форма.АутентификацияНаПользовательскомСайте");
		Если Результат = Неопределено ИЛИ ТипЗнч(Результат) = Тип("КодВозвратаДиалога") Тогда
			Возврат Ложь;
		Иначе
			КодПользователя = Результат.КодПользователя;
			Пароль          = Результат.Пароль;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеАутентификации = Новый Структура("КодПользователя ,Пароль", КодПользователя, Пароль);
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ЗагрузитьАдресныеОбъектыССервера(знач АдресныеОбъекты, знач ДанныеАутентификации, ПутьКДанным)
	
	Для Каждого АдресныйОбъект Из АдресныеОбъекты Цикл
		АдресныеСведения = АдресныйКлассификатор.ИнформацияПоАдресномуОбъекту(АдресныйОбъект);
		УстановитьСтатусЗагрузки(
		    СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		            НСтр("ru = 'Загрузка файлов с Веб сервера 1С: %1 %2.'"),
		                АдресныеСведения.Наименование,
		                АдресныеСведения.Сокращение));
		
		Результат = АдресныйКлассификаторКлиент.ЗагрузитьКЛАДРСВебСервера(
		                АдресныйОбъект,
		                ДанныеАутентификации,
		                ПутьКДанным);
		Если Не Результат.Статус Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Заполняет переданную таблицу значений по значениям таблицы адресных объектов.
// Выбирается код, наименование и сокращение типа объекта.
//
&НаСервере
Процедура ЗаполнитьТаблицуАдресныхОбъектов(ЗаданныеРегионыДляЗагрузки)
	
	МассивЗагружаемыхАО = ЗагрузитьНастройкуЗагрузкиКЛАДР("ЗагружаемыеРегионы");
	
	АдресныеОбъектыДляЗагрузки.Очистить();
	
	КлассификаторАдресныхОбъектовXML =
		РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("КлассификаторАдресныхОбъектовРоссии").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторАдресныхОбъектовXML).Данные;
	
	Для Каждого АдресныйОбъект Из КлассификаторТаблица Цикл
		
		Наименование = СокрЛП(Лев(АдресныйОбъект.Code, 2) + " - " + АдресныйОбъект.Name + " " + АдресныйОбъект.Socr);
		
		НоваяСтрока = АдресныеОбъектыДляЗагрузки.Добавить();
		НоваяСтрока.НаименованиеАдресногоОбъекта = Наименование;
		
		Если      ЗаданныеРегионыДляЗагрузки <> Неопределено Тогда
			//
			Если ЗаданныеРегионыДляЗагрузки.Найти(Лев(АдресныйОбъект.Code, 2)) <> Неопределено Тогда
				НоваяСтрока.Пометка = Истина;
			Иначе
				НоваяСтрока.Пометка = Ложь;
			КонецЕсли;
			//
		ИначеЕсли МассивЗагружаемыхАО <> Неопределено Тогда
			//
			Если МассивЗагружаемыхАО.Найти(Лев(АдресныйОбъект.Code, 2)) <> Неопределено Тогда
				НоваяСтрока.Пометка = Истина;
			Иначе
				НоваяСтрока.Пометка = Ложь;
			КонецЕсли;
		Иначе
			НоваяСтрока.Пометка = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗаданныеРегионыДляЗагрузки <> Неопределено Тогда
		//
		Если ЗаданныеРегионыДляЗагрузки.Найти("AL") <> Неопределено Тогда
			АдресныйОбъект = АдресныйКлассификатор.ИнформацияПоАдресномуОбъекту("AL");
			НоваяСтрока = АдресныеОбъектыДляЗагрузки.Добавить();
			НоваяСтрока.НаименованиеАдресногоОбъекта = СокрЛП(Лев(АдресныйОбъект.КодАдресногоОбъекта, 2) + " - " + АдресныйОбъект.Наименование);
			НоваяСтрока.Пометка = Истина;
			ОбязательныеАдресныеОбъекты.Добавить(НоваяСтрока.ПолучитьИдентификатор());
		КонецЕсли;
		//
		Если ЗаданныеРегионыДляЗагрузки.Найти("SO") <> Неопределено Тогда
			АдресныйОбъект = АдресныйКлассификатор.ИнформацияПоАдресномуОбъекту("SO");
			НоваяСтрока = АдресныеОбъектыДляЗагрузки.Добавить();
			НоваяСтрока.НаименованиеАдресногоОбъекта = СокрЛП(Лев(АдресныйОбъект.КодАдресногоОбъекта, 2) + " - " + АдресныйОбъект.Наименование);
			НоваяСтрока.Пометка = Истина;
			ОбязательныеАдресныеОбъекты.Добавить(НоваяСтрока.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает количество помеченных адресных объектов
//
&НаКлиенте
Функция КоличествоОтмеченныхАдресныхОбъектов()
	
	КоличествоОтмеченныхАдресныхОбъектов = 0;
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		Если ЭлементАдресныйОбъект.Пометка Тогда
			КоличествоОтмеченныхАдресныхОбъектов = КоличествоОтмеченныхАдресныхОбъектов + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат КоличествоОтмеченныхАдресныхОбъектов;
	
КонецФункции

// В зависимости от текущей страницы устанавливает доступность тех или иных полей для пользователя
//
&НаКлиенте
Процедура УстановитьИзмененияВИнтерфейсе()
	
	ИсточникДанныхДляЗагрузкиВыбран = ИсточникДанныхДляЗагрузкиВыбран();
	КоличествоОтмеченныхАдресныхОбъектов = КоличествоОтмеченныхАдресныхОбъектов();
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборАдресныхОбъектов Тогда
		Элементы.Назад.Доступность = Ложь;
		Элементы.Далее.Доступность = Истина;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника Тогда
		Элементы.Назад.Доступность = Истина;
		Элементы.Далее.Доступность = Истина;
		
		Если ИсточникДанныхДляЗагрузки = 0 Тогда
			ИсточникДанныхДляЗагрузки = 1;
		КонецЕсли;
		
		Если		ИсточникДанныхДляЗагрузки = 2 Тогда
			Элементы.СтраницыСпособаЗагрузки.ТекущаяСтраница = Элементы.СтраницаЗагрузкаСДискаИТС;
		ИначеЕсли	ИсточникДанныхДляЗагрузки = 3 Тогда
			Элементы.СтраницыСпособаЗагрузки.ТекущаяСтраница = Элементы.СтраницаЗагрузкаФайлов;
		Иначе
			Элементы.СтраницыСпособаЗагрузки.ТекущаяСтраница = Элементы.ПустаяСтраница;
		КонецЕсли;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
		Элементы.Назад.Доступность = Истина;
		Элементы.Далее.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ИсточникДанныхДляЗагрузкиВыбран()
	
	ИсточникВыбран = Ложь;
	
	Если     ИсточникДанныхДляЗагрузки = 1 Тогда
		ИсточникВыбран = Истина;
	ИначеЕсли ИсточникДанныхДляЗагрузки = 2 Тогда
		Если АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловНаДискеИТС(ДискИТС) Тогда
			ИсточникВыбран = Истина;
		КонецЕсли;
	ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
		Если АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловДанныхВКаталоге(ПутьКФайламДанныхНаДиске) Тогда
			ИсточникВыбран = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИсточникВыбран;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОтметитьОбязательные(Контекст)
	
	Для каждого Описание Из Контекст.ОбязательныеАдресныеОбъекты Цикл
		Контекст.АдресныеОбъектыДляЗагрузки.НайтиПоИдентификатору(Описание.Значение).Пометка = Истина;
	КонецЦикла
	
КонецПроцедуры
