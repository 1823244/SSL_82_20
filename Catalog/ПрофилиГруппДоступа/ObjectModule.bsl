﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обновляет табличную часть ТаблицыРолей в соответствии с составом ролей.
// Перед обновлением, обработчик проверяет наличие ролей в конфигурации и
// исключает из списка роль "Полные права".
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение множества возможных пустых ссылок, используемых как типы ссылок.
	Если Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
		ТипыСсылок.Загрузить(УправлениеДоступомСерверПовтИсп.ТипыСсылок());
	ИначеЕсли ТипыСсылок.Количество() <> 0 Тогда
		ТипыСсылок.Очистить();
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		// Проверка наличия ролей в конфигурации.
		НомерСтроки = Роли.Количество() - 1;
		Пока НомерСтроки >= 0 Цикл
			Если Метаданные.Роли.Найти(Роли[НомерСтроки].Роль) = Неопределено Тогда
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Управление доступом.Роль не найдена в метаданных'"),
				                         УровеньЖурналаРегистрации.Ошибка, , ,
				                         СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				                              НСтр("ru= 'При записи профиля групп доступа <%1> роль <%2> не найдена в метаданных.'"),
				                              Ссылка,
				                              Роли[НомерСтроки].Роль),
				                         РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
			ИначеЕсли ВРег(Роли[НомерСтроки].Роль) = ВРег("ПолныеПрава") И
				Ссылка <> Справочники.ПрофилиГруппДоступа.Администратор Тогда
				
				Роли.Удалить(НомерСтроки);
			ИначеЕсли ВРег(Роли[НомерСтроки].Роль) = ВРег("АдминистраторСистемы") И
				Ссылка <> Справочники.ПрофилиГруппДоступа.Администратор Тогда
				
				Роли.Удалить(НомерСтроки);
			КонецЕсли;
			НомерСтроки = НомерСтроки - 1;
		КонецЦикла;
		
		// Удаление всегда используемых видов доступа.
		ВидыДоступаИспользуемыеВсегда = УправлениеДоступом.СвойстваВидаДоступа().НайтиСтроки(Новый Структура("ВидДоступаИспользуетсяВсегда", Истина));
		Для каждого СвойстваВидаДоступа Из ВидыДоступаИспользуемыеВсегда Цикл
			Для каждого Строка ИЗ ВидыДоступа.НайтиСтроки(Новый Структура("ВидДоступа", СвойстваВидаДоступа.ВидДоступа)) Цикл
				ВидыДоступа.Удалить(Строка);
			КонецЦикла;
		КонецЦикла;
		
		Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРеквизитПоставляемыйПрофильИзменен") Тогда
			Если Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
				ПоставляемыйПрофильИзменен = Ложь;
			Иначе
				ПоставляемыйПрофильИзменен = УправлениеДоступомСобытия.ПоставляемыйПрофильИзменен(ЭтотОбъект);
			КонецЕсли;
		КонецЕсли;
		
		Если УправлениеДоступомПереопределяемый.УпрощенныйИнтерфейсНастройкиПравДоступа() Тогда
			// Обновление наименования у персональных групп доступа этого профиля (если есть)
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Профиль",      Ссылка);
			Запрос.УстановитьПараметр("Наименование", Наименование);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ГруппыДоступа.Ссылка
			|ИЗ
			|	Справочник.ГруппыДоступа КАК ГруппыДоступа
			|ГДЕ
			|	ГруппыДоступа.Профиль = &Профиль
			|	И ГруппыДоступа.Пользователь <> НЕОПРЕДЕЛЕНО
			|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
			|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.ВнешниеПользователи.ПустаяСсылка)
			|	И ГруппыДоступа.Наименование <> &Наименование";
			ИзмененныеГруппыДоступа = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
			Если ИзмененныеГруппыДоступа.Количество() > 0 Тогда
				Для каждого ГруппаДоступаСсылка Из ИзмененныеГруппыДоступа Цикл
					ПерсональнаяГруппаДоступаОбъект = ГруппаДоступаСсылка.ПолучитьОбъект();
					ПерсональнаяГруппаДоступаОбъект.Наименование = Наименование;
					ПерсональнаяГруппаДоступаОбъект.ОбменДанными.Загрузка = Истина;
					ПерсональнаяГруппаДоступаОбъект.Записать();
				КонецЦикла;
				ДополнительныеСвойства.Вставить("ПерсональныеГруппыДоступаСОбновленнымНаименованием", ИзмененныеГруппыДоступа);
			КонецЕсли;
		КонецЕсли;
		
		Если Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
			ТаблицыРолей.Очистить();
			Пользователь = Неопределено;
		Иначе
			ЗаполнитьТаблицыРолейПрофиляГруппДоступа(ЭтотОбъект);
		КонецЕсли;
		
		// При установке пометки удаления установка пометки удаления групп доступа профиля
		Если ПометкаУдаления И ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПометкаУдаления") = Ложь Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Профиль", Ссылка);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ГруппыДоступа.Ссылка
			|ИЗ
			|	Справочник.ГруппыДоступа КАК ГруппыДоступа
			|ГДЕ
			|	(НЕ ГруппыДоступа.ПометкаУдаления)
			|	И ГруппыДоступа.Профиль = &Профиль";
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
				ГруппаДоступаОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ГруппаДоступаОбъект.ПометкаУдаления = Истина;
				ГруппаДоступаОбъект.Записать();
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обновляет РегистрСведений.ТаблицыГруппДоступа и
// роли пользователей групп доступа с текущим профилем.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		Если ДополнительныеСвойства.Свойство("ОбновитьГруппыДоступаПрофиля") Тогда
			УправлениеДоступом.ОбновитьГруппыДоступаПрофиля(Ссылка, Ложь);
		КонецЕсли;
		
		// Обновление таблиц и значений групп доступа.
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ГруппыДоступа.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа КАК ГруппыДоступа
		|ГДЕ
		|	ГруппыДоступа.Профиль = &Профиль
		|	И (НЕ ГруппыДоступа.ЭтоГруппа)");
		Запрос.УстановитьПараметр("Профиль", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			УправлениеДоступом.ОбновитьТаблицыГруппДоступа(Выборка.Ссылка);
			УправлениеДоступом.ЗаписатьЗначенияГруппДоступа(Выборка.Ссылка);
		КонецЦикла;
		
		Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей") Тогда
			// Обновление ролей пользователей.
			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ПользователиИГруппыПользователей.ЗначениеДоступа КАК Пользователь
			|ИЗ
			|	РегистрСведений.ГруппыЗначенийДоступа КАК ПользователиИГруппыПользователей
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
			|		ПО (ПользователиИГруппыПользователей.ВидДоступа = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПустаяСсылка))
			|			И (ПользователиИГруппыПользователей.ТолькоВидДоступа = ЛОЖЬ)
			|			И ПользователиИГруппыПользователей.ГруппаДоступа = ГруппыДоступаПользователи.Пользователь
			|			И (ГруппыДоступаПользователи.Ссылка.Профиль = &Профиль)
			|			И (ТИПЗНАЧЕНИЯ(ПользователиИГруппыПользователей.ЗначениеДоступа) = ТИП(Справочник.Пользователи)
			|				ИЛИ ТИПЗНАЧЕНИЯ(ПользователиИГруппыПользователей.ЗначениеДоступа) = ТИП(Справочник.ВнешниеПользователи))");
			Запрос.УстановитьПараметр("Профиль", Ссылка);
			ПользователиПрофиля = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
			
			УправлениеДоступом.ОбновитьРолиПользователей(ПользователиПрофиля);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
			ПроверяемыеРеквизиты, ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура ЗаполнитьТаблицыРолейПрофиляГруппДоступа
// заполняет табличную часть ТаблицыРолей профиля групп доступа.
// 
// Параметры:
//  Профиль      - СправочникОбъект.ПрофилиГруппДоступа.
//
Процедура ЗаполнитьТаблицыРолейПрофиляГруппДоступа(Знач Профиль)
	
	ПраваОМДРолей = УправлениеДоступомСерверПовтИсп.ОграничиваемыеПраваОбъектовМетаданныхРолей();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПраваОМДРолей", ПраваОМДРолей);
	Запрос.УстановитьПараметр("РолиПрофиля", Профиль.Роли.ВыгрузитьКолонку("Роль"));
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваОМДРолей.Роль,
	|	ПраваОМДРолей.Таблица,
	|	ПраваОМДРолей.Добавление,
	|	ПраваОМДРолей.Изменение,
	|	ПраваОМДРолей.Удаление,
	|	ПраваОМДРолей.ТипТаблицы
	|ПОМЕСТИТЬ ТаблицыРолей
	|ИЗ
	|	&ПраваОМДРолей КАК ПраваОМДРолей
	|ГДЕ
	|	ПраваОМДРолей.Роль В(&РолиПрофиля)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицыРолей.Роль,
	|	ТаблицыРолей.Таблица,
	|	ТаблицыРолей.Добавление,
	|	ТаблицыРолей.Изменение,
	|	ТаблицыРолей.Удаление,
	|	ТаблицыРолей.ТипТаблицы
	|ИЗ
	|	ТаблицыРолей КАК ТаблицыРолей";
	
	Профиль.ТаблицыРолей.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры


