﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-процессы и задачи"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Инициализирует общие параметры формы выполнения задачи.
//
// Параметры:
//  ФормаЗадачи  - УправляемаяФорма  - форма выполнения задачи.
//  ЗадачаОбъект - ЗадачаОбъект      - объект задачи.
//  ЭлементГруппаСостояние - элемент управления формы - группа с информации о
//                                                      состоянии задачи  
//  ЭлементДатаИсполнения  - элемент управления формы - поле с датой исполнения задачи 
//
Процедура ФормаЗадачиПриСозданииНаСервере(ФормаЗадачи, ЗадачаОбъект, 
	ЭлементГруппаСостояние, ЭлементДатаИсполнения) Экспорт
	
	ФормаЗадачи.ТолькоПросмотр = ЗадачаОбъект.Выполнена;
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	ЭлементДатаИсполнения.Вид = ?(ИзменятьЗаданияЗаднимЧислом, ВидПоляФормы.ПолеВвода, ВидПоляФормы.ПолеНадписи);

	ЭлементГруппаСостояние.Видимость = ЗадачаОбъект.Выполнена;
	Если ЗадачаОбъект.Выполнена Тогда
		Родитель = ?(ЭлементГруппаСостояние <> Неопределено, ЭлементГруппаСостояние, ФормаЗадачи);
		Элемент = ФормаЗадачи.Элементы.Найти("__СостояниеЗадачиКартинка");
		Если Элемент = Неопределено Тогда
			Элемент = ФормаЗадачи.Элементы.Добавить("__СостояниеЗадачиКартинка", Тип("ДекорацияФормы"), Родитель);
			Элемент.Вид = ВидДекорацииФормы.Картинка;
			Элемент.Картинка = БиблиотекаКартинок.Информация32;
			Элемент.Высота = 2;
			Элемент.Ширина = 4;
		КонецЕсли;
		
		Элемент = ФормаЗадачи.Элементы.Найти("__СостояниеЗадачи");
		Если Элемент = Неопределено Тогда
			Элемент = ФормаЗадачи.Элементы.Добавить("__СостояниеЗадачи", Тип("ДекорацияФормы"), Родитель);
			Элемент.Вид = ВидДекорацииФормы.Надпись;
			Элемент.Высота = 2;
		КонецЕсли;
		ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
		ДатаИсполненияСтрокой = ?(ИспользоватьДатуИВремяВСрокахЗадач, 
			Формат(ЗадачаОбъект.ДатаИсполнения, "ДЛФ=DT"), Формат(ЗадачаОбъект.ДатаИсполнения, "ДЛФ=D"));
		Элемент.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru ='Задача выполнена %1 пользователем %2.'"),
				ДатаИсполненияСтрокой, 
				ИсполнительСтрокой(ЗадачаОбъект.Исполнитель, ЗадачаОбъект.РольИсполнителя,
				ЗадачаОбъект.ОсновнойОбъектАдресации, ЗадачаОбъект.ДополнительныйОбъектАдресации));
	КонецЕсли;
	
	Если БизнесПроцессыИЗадачиВызовСервера.ЭтоВедущаяЗадача(ЗадачаОбъект.Ссылка) Тогда
		Родитель = ?(ЭлементГруппаСостояние <> Неопределено, ЭлементГруппаСостояние, ФормаЗадачи);
		Элемент = ФормаЗадачи.Элементы.Найти("__ВедущаяЗадачаКартинка");
		Если Элемент = Неопределено Тогда
			Элемент = ФормаЗадачи.Элементы.Добавить("__ВедущаяЗадачаКартинка", Тип("ДекорацияФормы"), Родитель);
			Элемент.Вид = ВидДекорацииФормы.Картинка;
			Элемент.Картинка = БиблиотекаКартинок.Информация32;
			Элемент.Высота = 2;
			Элемент.Ширина = 4;
		КонецЕсли;
		
		Элемент = ФормаЗадачи.Элементы.Найти("__ВедущаяЗадача");
		Если Элемент = Неопределено Тогда
			Элемент = ФормаЗадачи.Элементы.Добавить("__ВедущаяЗадача", Тип("ДекорацияФормы"), Родитель);
			Элемент.Вид = ВидДекорацииФормы.Надпись;
			Элемент.Заголовок = НСтр("ru ='Это ведущая задача для вложенных бизнес-процессов.'");
			Элемент.Высота = 2;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры             

// Вызывается при создании формы списка задач на сервере.
//
// Параметры
//  УсловноеОформлениеСпискаЗадач - УсловноеОформление - условное оформление списка задач
//
Процедура УстановитьОформлениеЗадач(Знач УсловноеОформлениеСпискаЗадач) Экспорт

	// установка оформления для просроченных задач
	ЭлементУсловногоОформления = УсловноеОформлениеСпискаЗадач.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = ТекущаяДатаСеанса();
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Выполнена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение =  Метаданные.ЭлементыСтиля.ПросроченныеДанныеЦвет.Значение;   
	ЭлементЦветаОформления.Использование = Истина;
	
	// установка оформления для выполненных задач
	ЭлементУсловногоОформления = УсловноеОформлениеСпискаЗадач.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Выполнена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ВыполненнаяЗадача.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
	// установка оформления для задач, не принятых к исполнению
	ЭлементУсловногоОформления = УсловноеОформлениеСпискаЗадач.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПринятаКИсполнению");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Font");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.НеПринятыеКИсполнениюЗадачи.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
КонецПроцедуры

// Возвращает строковое представление исполнителя задачи Исполнитель, 
// либо указанного в параметрах РольИсполнителя, ОсновнойОбъектАдресации и ДополнительныйОбъектАдресации.
//
// Параметры:
//  Исполнитель     - ПользовательСсылка  - исполнитель задачи.
//  РольИсполнителя  – Справочники.РолиИсполнителей – роль
//  ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации - произвольный ссылочный тип.
//
// Возвращаемое значение:
//   Строка 
//
Функция ИсполнительСтрокой(Знач Исполнитель, Знач РольИсполнителя,
	Знач ОсновнойОбъектАдресации = Неопределено, Знач ДополнительныйОбъектАдресации = Неопределено) Экспорт
	
	Если НЕ Исполнитель.Пустая() Тогда
		Возврат Строка(Исполнитель)
	ИначеЕсли НЕ РольИсполнителя.Пустая() Тогда
		Возврат РольСтрокой(РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации);
	КонецЕсли;
	Возврат НСтр("ru = 'Не указан'");

КонецФункции

// Возвращает строковое представление роли РольИсполнителя.
//
// Параметры
//  РольИсполнителя  – Справочники.РолиИсполнителей – роль
//  ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации - произвольный ссылочный тип.
//
// Возвращаемое значение:
//   Строка 
//
Функция РольСтрокой(Знач РольИсполнителя,
	Знач ОсновнойОбъектАдресации = Неопределено, Знач ДополнительныйОбъектАдресации = Неопределено) Экспорт
	
	Если НЕ РольИсполнителя.Пустая() Тогда
		Результат = Строка(РольИсполнителя);
		Если ОсновнойОбъектАдресации <> Неопределено Тогда
			Результат = Результат + " (" + Строка(ОсновнойОбъектАдресации);
			Если ДополнительныйОбъектАдресации <> Неопределено Тогда
				Результат = Результат + " ," + Строка(ДополнительныйОбъектАдресации);
			КонецЕсли;
			Результат = Результат + ")";
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;
	Возврат НСтр("ru = 'Не указана'");

КонецФункции

// Помечает на удаление задачи бизнес-процесса БизнесПроцессСсылка.
//
// Параметры
//  БизнесПроцессСсылка  - бизнес-процесс
//  ПометкаУдаления  - Булево - значение свойства ПометкаУдаления.
//
Процедура УстановитьПометкуУдаленияЗадач(БизнесПроцессСсылка, ПометкаУдаления) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос("ВЫБРАТЬ
			|	Задачи.Ссылка КАК Ссылка 
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК Задачи
			|ГДЕ
			|	Задачи.БизнесПроцесс = &БизнесПроцесс");
		Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцессСсылка);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
		КонецЦикла;	
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, 
			БизнесПроцессСсылка.Метаданные(), БизнесПроцессСсылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры	

// Установить формат отображения и редактирования поля формы типа Дата
// в зависимости от настроек подсистемы.
//
// Параметры
//  ПолеДаты  - элемент управления формы, поле со значением типа Дата.
//
Процедура УстановитьФорматДаты(ПолеДаты) Экспорт
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	СтрокаФормата = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Если ПолеДаты.Вид = ВидПоляФормы.ПолеВвода Тогда
		ПолеДаты.ФорматРедактирования 	= СтрокаФормата;
	Иначе	
		ПолеДаты.Формат					= СтрокаФормата;
	КонецЕсли;	
	ПолеДаты.Ширина = ?(ИспользоватьДатуИВремяВСрокахЗадач, 0, 8);
	
КонецПроцедуры		

// Проверяет, является ли указанная задача ведущей.
//
// Параметры
//  ЗадачаСсылка  - задача.
//
// Возвращаемое значение:
//   Булево
//
Функция БизнесПроцессыВедущейЗадачи(ЗадачаСсылка) Экспорт
	
	Результат = ВыбратьБизнесПроцессыВедущейЗадачи(ЗадачаСсылка);
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Выбрать список ролей, которые могут быть назначены в ОсновнойОбъектАдресации,
// и посчитать список назначений.
//
Функция ВыбратьРолиСКоличествомИсполнителей(ОсновнойОбъектАдресации) Экспорт
	Если ОсновнойОбъектАдресации <> Неопределено Тогда
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	РолиИсполнителей.Ссылка КАК РольСсылка,
			|	РолиИсполнителей.Наименование КАК Роль,
			|	РолиИсполнителей.ВнешняяРоль КАК ВнешняяРоль,
			|	РолиИсполнителей.ТипыОсновногоОбъектаАдресации КАК ТипыОсновногоОбъектаАдресации,
			|	СУММА(ВЫБОР
			|			КОГДА ИсполнителиЗадач.РольИсполнителя <> ЗНАЧЕНИЕ(Справочник.РолиИсполнителей.ПустаяСсылка) 
			|				И ИсполнителиЗадач.РольИсполнителя ЕСТЬ НЕ NULL 
			|				И ИсполнителиЗадач.ОсновнойОбъектАдресации = &ОсновнойОбъектАдресации
			|				ТОГДА 1
			|			ИНАЧЕ 0
			|		КОНЕЦ) КАК Исполнители
			|ИЗ
			|	Справочник.РолиИсполнителей КАК РолиИсполнителей
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
			|		ПО (ИсполнителиЗадач.РольИсполнителя = РолиИсполнителей.Ссылка)
			|ГДЕ
			|	РолиИсполнителей.ПометкаУдаления = ЛОЖЬ
			|	И РолиИсполнителей.ИспользуетсяСОбъектамиАдресации = ИСТИНА
			| СГРУППИРОВАТЬ ПО
			|	РолиИсполнителей.Ссылка,
			|	ИсполнителиЗадач.РольИсполнителя, 
			|	РолиИсполнителей.ВнешняяРоль,
			|	РолиИсполнителей.Наименование,
			|	РолиИсполнителей.ТипыОсновногоОбъектаАдресации";
	Иначе
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	РолиИсполнителей.Ссылка КАК РольСсылка,
			|	РолиИсполнителей.Наименование КАК Роль,
			|	РолиИсполнителей.ВнешняяРоль КАК ВнешняяРоль,
			|	РолиИсполнителей.ТипыОсновногоОбъектаАдресации КАК ТипыОсновногоОбъектаАдресации,
			|	СУММА(ВЫБОР
			|			КОГДА ИсполнителиЗадач.РольИсполнителя <> ЗНАЧЕНИЕ(Справочник.РолиИсполнителей.ПустаяСсылка) 
			|				И ИсполнителиЗадач.РольИсполнителя ЕСТЬ НЕ NULL 
			|				И (ИсполнителиЗадач.ОсновнойОбъектАдресации ЕСТЬ NULL 
			|					ИЛИ ИсполнителиЗадач.ОсновнойОбъектАдресации = Неопределено)
			|				ТОГДА 1
			|			ИНАЧЕ 0
			|		КОНЕЦ) КАК Исполнители
			|ИЗ
			|	Справочник.РолиИсполнителей КАК РолиИсполнителей
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
			|		ПО (ИсполнителиЗадач.РольИсполнителя = РолиИсполнителей.Ссылка)
			|ГДЕ
			|	РолиИсполнителей.ПометкаУдаления = ЛОЖЬ
			|	И РолиИсполнителей.ИспользуетсяБезОбъектовАдресации = ИСТИНА
			| СГРУППИРОВАТЬ ПО
			|	РолиИсполнителей.Ссылка,
			|	ИсполнителиЗадач.РольИсполнителя, 
			|	РолиИсполнителей.ВнешняяРоль,
			|	РолиИсполнителей.Наименование, 
			|	РолиИсполнителей.ТипыОсновногоОбъектаАдресации";
	КонецЕсли;		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.Параметры.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	Возврат ВыборкаЗапроса;
	
КонецФункции

// Выбрать список исполнителей, назначенных на указанную роль.
//
// Результат:
//    Массив - массив элементов справочника Пользователи.
//
Функция ИсполнителиРоли(РольСсылка, ОсновнойОбъектАдресации = Неопределено,
	ДополнительныйОбъектАдресации = Неопределено) Экспорт
	
	РезультатЗапроса = ВыбратьИсполнителейРоли(РольСсылка, ОсновнойОбъектАдресации,
		ДополнительныйОбъектАдресации);
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Исполнитель");	
	
КонецФункции

// Есть ли хотя бы один исполнитель, назначенный на указанную роль.
//
// Результат:
//   Булево
//
Функция ЕстьИсполнителиРоли(РольСсылка, ОсновнойОбъектАдресации = Неопределено,
	ДополнительныйОбъектАдресации = Неопределено) Экспорт
	
	РезультатЗапроса = ВыбратьИсполнителейРоли(РольСсылка, ОсновнойОбъектАдресации,
		ДополнительныйОбъектАдресации);
	Возврат НЕ РезультатЗапроса.Пустой();	
	
КонецФункции

Функция ВыбратьИсполнителейРоли(РольСсылка, ОсновнойОбъектАдресации = Неопределено,
	ДополнительныйОбъектАдресации = Неопределено)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
	   |	ИсполнителиЗадач.Исполнитель
	   |ИЗ
	   |	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	   |ГДЕ
	   |	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя";
	Если ОсновнойОбъектАдресации <> Неопределено Тогда  
		ТекстЗапроса = ТекстЗапроса +
	   		"	И ИсполнителиЗадач.ОсновнойОбъектАдресации = &ОсновнойОбъектАдресации";
	КонецЕсли;		
	Если ДополнительныйОбъектАдресации <> Неопределено Тогда  
		ТекстЗапроса = ТекстЗапроса +
		 	"	И ИсполнителиЗадач.ДополнительныйОбъектАдресации = &ДополнительныйОбъектАдресации";
	КонецЕсли;		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.Параметры.Вставить("РольИсполнителя", РольСсылка);
	Запрос.Параметры.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Запрос.Параметры.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса;
	
КонецФункции

// Выбрать одного любого исполнителя, назначенного на РольИсполнителя в ОсновнойОбъектАдресации.
// 
Функция ВыбратьИсполнителя(ОсновнойОбъектАдресации, РольИсполнителя) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ИсполнителиЗадач.Исполнитель КАК Исполнитель
		|ИЗ
		|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
		|ГДЕ
		|	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
		|	И ИсполнителиЗадач.ОсновнойОбъектАдресации = &ОсновнойОбъектАдресации"
	);
	Запрос.Параметры.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Запрос.Параметры.Вставить("РольИсполнителя", РольИсполнителя);
	ВыборкаЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат ?(ВыборкаЗапроса.Количество() > 0, ВыборкаЗапроса[0].Исполнитель, Справочники.Пользователи.ПустаяСсылка());
	
КонецФункции	

// Получить бизнес-процессы ведущей задачи ЗадачаСсылка.
//
Функция ВыбратьБизнесПроцессыВедущейЗадачи(ЗадачаСсылка) Экспорт
	
	Итерация = 1;
	ТекстЗапроса = "";
	Для Каждого ТипБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		Если НЕ ПустаяСтрока(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса + "
				|
				|ОБЪЕДИНИТЬ
				|";
				
		КонецЕсли;
		ФрагментЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"ВЫБРАТЬ %3
			|	%1.Ссылка КАК Ссылка
			|ИЗ
			|	%2 КАК %1
			|ГДЕ
			|	%1.ВедущаяЗадача = &ВедущаяЗадача", ТипБизнесПроцесса.Имя, ТипБизнесПроцесса.ПолноеИмя(),
			?(Итерация = 1, "РАЗРЕШЕННЫЕ", ""));
		ТекстЗапроса = ТекстЗапроса + ФрагментЗапроса;
		Итерация = Итерация + 1;
	КонецЦикла;	
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ВедущаяЗадача", ЗадачаСсылка);
	Результат = Запрос.Выполнить();
	Возврат Результат;
		
КонецФункции	

// Вид события журнала регистрации для событий данной подсистемы.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	Возврат НСтр("ru = 'Бизнес-процессы и задачи'");
КонецФункции

// Вызывается при изменении состояния бизнес-процесса для того, чтобы 
// распространить это изменение состояния на невыполненные задачи этого 
// бизнес-процесса.
//
Процедура ПриИзмененииСостоянияБизнесПроцесса(БизнесПроцесс, СтароеСостояние, НовоеСостояние) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачаИсполнителя.Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
		|	И ЗадачаИсполнителя.Выполнена = Ложь";

	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс.Ссылка);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Задача = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Задача.Заблокировать();
		Задача.СостояниеБизнесПроцесса =  НовоеСостояние;
		Задача.Записать();
		
		ПриИзмененииСостоянияЗадачи(Задача.Ссылка, СтароеСостояние, НовоеСостояние);
	КонецЦикла;

КонецПроцедуры

Процедура ПриИзмененииСостоянияЗадачи(ЗадачаСсылка, СтароеСостояние, НовоеСостояние)
	
	// Меняем состояние вложенных бизнес-процессов
	Для каждого МетаданныеБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		
		Если ПравоДоступа("Изменение", МетаданныеБизнесПроцесса) Тогда
		
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	БизнесПроцессы.Ссылка
				|ИЗ
				|	%БизнесПроцесс% КАК БизнесПроцессы
				|ГДЕ
				|   БизнесПроцессы.ВедущаяЗадача = &ВедущаяЗадача
				|   И БизнесПроцессы.ПометкаУдаления = Ложь
				| 	И БизнесПроцессы.Завершен = Ложь";
				
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%БизнесПроцесс%", МетаданныеБизнесПроцесса.ПолноеИмя());
			Запрос.УстановитьПараметр("ВедущаяЗадача", ЗадачаСсылка);

			Результат = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = Результат.Выбрать();

			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				БизнесПроцесс = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
				БизнесПроцесс.Состояние = НовоеСостояние;
				БизнесПроцесс.Записать();
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;	
	
	// Меняем состояние подчиненных бизнес-процессов
	Для каждого МетаданныеБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		
		РеквизитГлавнаяЗадача = МетаданныеБизнесПроцесса.Реквизиты.Найти("ГлавнаяЗадача");
		Если РеквизитГлавнаяЗадача = Неопределено Тогда
			Продолжить;
		КонецЕсли;	
			
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	БизнесПроцессы.Ссылка
			|ИЗ
			|	%БизнесПроцесс% КАК БизнесПроцессы
			|ГДЕ
			|   БизнесПроцессы.ГлавнаяЗадача = &ГлавнаяЗадача
			|   И БизнесПроцессы.ПометкаУдаления = Ложь
			| 	И БизнесПроцессы.Завершен = Ложь";
			
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%БизнесПроцесс%", МетаданныеБизнесПроцесса.ПолноеИмя());
		Запрос.УстановитьПараметр("ГлавнаяЗадача", ЗадачаСсылка);

		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			БизнесПроцесс = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			БизнесПроцесс.Состояние = НовоеСостояние;
			БизнесПроцесс.Записать();
			
		КонецЦикла;
		
	КонецЦикла;	
	
КонецПроцедуры
	
// Заполняет реквизит ГлавнаяЗадача при создании бизнес-процесса
// на основании другого бизнес-процесса
//
Процедура ЗаполнитьГлавнуюЗадачу(БизнесПроцессОбъект, ДанныеЗаполнения) Экспорт
	
	Если БизнесПроцессыИЗадачиПереопределяемый.ЗаполнитьГлавнуюЗадачу(БизнесПроцессОбъект, ДанныеЗаполнения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЗаполнения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		БизнесПроцессОбъект.ГлавнаяЗадача = ДанныеЗаполнения;
	КонецЕсли;
	
КонецПроцедуры		

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
	Обработчик.Версия = "1.0.2.2";
	Обработчик.Процедура = "БизнесПроцессыИЗадачиСервер.ОбновлениеИнформационнойБазы";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.6.6";
	Обработчик.Процедура = "БизнесПроцессыИЗадачиСервер.ОбновлениеИнформационнойБазыПредметСтрокой";

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.2";
	Обработчик.Процедура = "БизнесПроцессыИЗадачиСервер.ОбновлениеСостоянияИПринятияКИсполнению";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.1.1";
	Обработчик.Процедура = "БизнесПроцессыИЗадачиСервер.ОбновлениеКодаРолиИсполнителя";
	
КонецПроцедуры	
	
// Инициализировать предпопределенную роль исполнителей ОтветственныйЗаКонтрольИсполнения.
// 
Процедура ОбновлениеИнформационнойБазы() Экспорт
	
	ВсеОбъектыАдресации = ПланыВидовХарактеристик.ОбъектыАдресацииЗадач.ВсеОбъектыАдресации;
	
	РольОбъект = Справочники.РолиИсполнителей.ОтветственныйЗаКонтрольИсполнения.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(РольОбъект.Ссылка);
	РольОбъект.ИспользуетсяБезОбъектовАдресации = Истина;
	РольОбъект.ИспользуетсяСОбъектамиАдресации = Истина;
	РольОбъект.ТипыОсновногоОбъектаАдресации = ВсеОбъектыАдресации;
	РольОбъект.Записать();
	
КонецПроцедуры

// Инициализировать новое поле Состояние у тех бизнес-процессов, у которых оно есть.
// 
Процедура ОбновлениеСостоянияИПринятияКИсполнению() Экспорт
	
	// Обновления состояния бизнес-процессов и задач
	Для каждого МетаданныеБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		
		РеквизитСостояние = МетаданныеБизнесПроцесса.Реквизиты.Найти("Состояние");
		Если РеквизитСостояние = Неопределено Тогда
			Продолжить;
		КонецЕсли;	
			
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ 
			|	БизнесПроцессы.Ссылка
			|ИЗ
			|	%БизнесПроцесс% КАК БизнесПроцессы";
			
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%БизнесПроцесс%", МетаданныеБизнесПроцесса.ПолноеИмя());

		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			БизнесПроцесс = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			БизнесПроцесс.Заблокировать();
			БизнесПроцесс.Состояние = Перечисления.СостоянияБизнесПроцессов.Активен;
			БизнесПроцесс.Записать();
			
		КонецЦикла;
		
	КонецЦикла;	
	
	// Обновления принятия к исполнению задач
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ 
		|	Задачи.Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК Задачи";
		
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		Если ЗадачаОбъект.Выполнена = Истина Тогда
			ЗадачаОбъект.ПринятаКИсполнению = Истина;
			ЗадачаОбъект.ДатаПринятияКИсполнению = ЗадачаОбъект.ДатаИсполнения;
		КонецЕсли;	
		
		ЗадачаОбъект.СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Активен;
		
		ЗадачаОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры	

// Заполнить новое поле ПредметСтрокой у задачи ЗадачаИсполнителя.
// 
Процедура ОбновлениеИнформационнойБазыПредметСтрокой() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачаИсполнителя.Ссылка КАК Ссылка,
		|	ЗадачаИсполнителя.Предмет КАК Предмет
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя";

	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ПредметСсылка = ВыборкаДетальныеЗаписи.Предмет;
		Если ПредметСсылка = Неопределено ИЛИ ПредметСсылка.Пустая() Тогда
			Продолжить;	
		КонецЕсли;	
		
		ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ЗадачаОбъект.ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(ПредметСсылка);
		ЗадачаОбъект.Записать();
		
	КонецЦикла;

КонецПроцедуры

// Перенести данные из стандартного реквизита Код в новый реквизит КраткоеПредставление.
// 
Процедура ОбновлениеКодаРолиИсполнителя() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РолиИсполнителей.Ссылка,
		|	РолиИсполнителей.Код
		|ИЗ
		|	Справочник.РолиИсполнителей КАК РолиИсполнителей";

	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ЗначениеКода = ВыборкаДетальныеЗаписи.Код;
		Если ПустаяСтрока(ЗначениеКода) Тогда
			Продолжить;	
		КонецЕсли;	
		
		РольИсполнителейОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		РольИсполнителейОбъект.КраткоеПредставление = ЗначениеКода;
		РольИсполнителейОбъект.Записать();
		
	КонецЦикла;

КонецПроцедуры

