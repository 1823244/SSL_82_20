﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Запрет редактирования реквизитов объектов".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Разрешает редактирование заблокированных элементов формы, связанных с заданными реквизитами.
Функция РазрешитьРедактированиеРеквизитовОбъекта(Знач Форма) Экспорт
	
	ЗаблокированныеРеквизиты = РеквизитыКромеНевидимых(Форма);
	
	Если ЗаблокированныеРеквизиты.Количество() = 0 Тогда
		ПредупреждениеВсеВидимыеРеквизитыРазблокированы();
		Возврат Ложь;
	КонецЕсли;
	
	СинонимыРеквизитов = Новый Массив;
	
	Для Каждого ОписаниеРеквизита Из Форма.ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если ЗаблокированныеРеквизиты.Найти(ОписаниеРеквизита.ИмяРеквизита) <> Неопределено Тогда
			СинонимыРеквизитов.Добавить(ОписаниеРеквизита.Представление);
		КонецЕсли;
	КонецЦикла;
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Форма.Объект.Ссылка);
	
	Результат = ПроверитьСсылкиНаОбъект(МассивСсылок, СинонимыРеквизитов);
	
	Если Результат Тогда
		УстановитьРазрешенностьРедактированияРеквизитов(Форма, ЗаблокированныеРеквизиты);
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Устанавливает доступность элементов формы, связанных с заданными реквизитами,
// для которых установлено разрешение изменения. Если передать массив реквизитов,
// тогда сначала будет дополнен состав реквизитов разрешенных для изменения.
//   Если разблокировка элементов формы, связанных с заданными реквизитами
// снята для всех реквизитов, тогда кнопка разрешения редактирования блокируется.
//
// Параметры:
//  Форма        - УправляемаяФорма - форма, в которой требуется разрешить
//                 редактирование элементов формы, заданных реквизитов.
//  
//  Реквизиты    - Массив       - имена реквизитов, для которых нужно установить разрешенность изменения.
//                                Используется, когда функция РазрешитьРедактированиеРеквизитовОбъекта
//                                не используется.
//                 Неопределено - состав реквизитов доступных для редактирования не изменяется,
//                                а для элементов формы, связанных с реквизитами, изменение которых
//                                разрешено устанавливается доступность.
//
Процедура УстановитьДоступностьЭлементовФормы(Знач Форма, Знач Реквизиты = Неопределено) Экспорт
	
	УстановитьРазрешенностьРедактированияРеквизитов(Форма, Реквизиты);
	
	Для Каждого ОписаниеБлокируемогоРеквизита Из Форма.ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено Тогда
			Для Каждого БлокируемыйЭлементФормы Из ОписаниеБлокируемогоРеквизита.БлокируемыеЭлементы Цикл
				ЭлементФормы = Форма.Элементы.Найти(БлокируемыйЭлементФормы.Значение);
				Если ЭлементФормы <> Неопределено Тогда
					Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы")
					 ИЛИ ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы") Тогда
						ЭлементФормы.ТолькоПросмотр = Ложь;
					Иначе
						ЭлементФормы.Доступность = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


// Спрашивает у пользователя подтверждение на включение редактирования реквизитов
// и проверяет есть ли ссылки на объект в информационной базе
//
Функция ПроверитьСсылкиНаОбъект(Знач МассивСсылок, Знач СинонимыРеквизитов) Экспорт
	
	Результат = Ложь;
	
	ЗаголовокДиалога = НСтр("ru = 'Редактирование реквизитов объекта'");
	
	РеквизитыПредставление = "";
	
	Для Каждого СинонимРеквизита Из СинонимыРеквизитов Цикл
		РеквизитыПредставление = РеквизитыПредставление + СинонимРеквизита + "," + Символы.ПС;
	КонецЦикла;
	
	РеквизитыПредставление = Лев(РеквизитыПредставление, СтрДлина(РеквизитыПредставление)-2);
	
	Если СинонимыРеквизитов.Количество() > 1 Тогда
		ТекстВопроса = НСтр("ru = 'Изменение следующих реквизитов может привести к рассогласованию
		                          |данных информационной базы:
		                          |
		                          |%1.
		                          |
		                          |Настоятельно рекомендуется проверить все случаи использования
		                          |объекта и оценить последствия изменения этих реквизитов.'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Изменение реквизита ""%1""
		                          |может привести к рассогласованию данных информационной базы.
		                          |
		                          |Настоятельно рекомендуется проверить все случаи использования
		                          |объекта и оценить последствия изменения этого реквизита.'");
	КонецЕсли;
	
	ТекстВопроса = ТекстВопроса + Символы.ПС + Символы.ПС;
	
	Если МассивСсылок.Количество() = 1 Тогда
		ТекстВопроса = ТекстВопроса + НСтр("ru = 'Продолжить с проверкой использования объекта?'");
	Иначе
		Если Прав(Строка(МассивСсылок.Количество()), 1) = "1" Тогда
			ШаблонТекстаВопроса = НСтр("ru = 'Разрешить редактирование реквизитов для %1 объекта?'");
		Иначе
			ШаблонТекстаВопроса = НСтр("ru = 'Разрешить редактирование реквизитов для %1 объектов?'");
		КонецЕсли;
		ТекстВопроса = ТекстВопроса
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаВопроса, МассивСсылок.Количество());
	КонецЕсли;
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, РеквизитыПредставление);
	
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, ЗаголовокДиалога);
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Если МассивСсылок.Количество() = 1 Тогда
			Если ОбщегоНазначения.ОбъектИспользуютсяВБазеДанных(МассивСсылок) Тогда
				
				ТекстСообщения = НСтр("ru = 'Редактируемый объект используется в информационной базе.
				                            |
				                            |Разрешить редактирование реквизитов объекта?'");
				
				Ответ = Вопрос(ТекстСообщения, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, ЗаголовокДиалога);
				
				Если Ответ = КодВозвратаДиалога.Да Тогда
					Результат = Истина;
				КонецЕсли;
			Иначе
				ТекстСообщения = НСтр("ru = 'Редактируемый объект не используется в информационной базе.
				                            |
				                            |Редактирование реквизитов объекта разрешено.'");
				Предупреждение(ТекстСообщения, , ЗаголовокДиалога);
				Результат = Истина;
			КонецЕсли;
			
		Иначе
			Результат = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Устанавливает разрешенность редактирования для тех реквизитов, описание которых подготовлено в форме.
//  Используется, когда доступность элементов формы изменяется самостоятельно, без
// использования функции УстановитьДоступностьЭлементовФормы.
//
// Параметры:
//  Форма        - УправляемаяФорма - форма, в которой требуется разрешить
//                 редактирование реквизитов объекта.
//  
//  Реквизиты    - Массив - реквизиты, которые нужно пометить, как разрешенные для изменения.
//  
//  РедактированиеРазрешено - Булево, начальное значение Истина - значение разрешенности редактирования реквизитов,
//                 которое нужно установить. Значение не будет установлено Истина, если нет права редактирования реквизита.
//                 Неопределено - не изменять разрешенность редактирования реквизитов.
//                 Ложь, Истина - установить указанное значение разрешенности редактирования реквизитов.
// 
//  ПравоРедактирования - Булево, начальное значение Неопределено - позволяет переопределить или доопределить
//                 возможность разблокировки реквизитов, которая вычисляется автоматически с помощью метода ПравоДоступа.
//                 Неопределено - не изменять ПравоРедактирования
//                 Ложь, Истина - установить указанное значение ПраваРедактирования для указанных реквизитов.
// 
Процедура УстановитьРазрешенностьРедактированияРеквизитов(Знач Форма, Знач Реквизиты, Знач РедактированиеРазрешено = Истина, Знач ПравоРедактирования = Неопределено) Экспорт
	
	Если ТипЗнч(Реквизиты) = Тип("Массив") Тогда
		
		Для Каждого Реквизит Из Реквизиты Цикл
			ОписаниеРеквизита = Форма.ПараметрыЗапретаРедактированияРеквизитов.НайтиСтроки(Новый Структура("ИмяРеквизита", Реквизит))[0];
			Если ТипЗнч(ПравоРедактирования) = Тип("Булево") Тогда
				ОписаниеРеквизита.ПравоРедактирования = ПравоРедактирования;
			КонецЕсли;
			Если ТипЗнч(РедактированиеРазрешено) = Тип("Булево") Тогда
				ОписаниеРеквизита.РедактированиеРазрешено = ОписаниеРеквизита.ПравоРедактирования И РедактированиеРазрешено;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Обновление доступности команды РазрешитьРедактированиеРеквизитовОбъекта
	ВсеРеквизитыРазблокированы = Истина;
	
	Для каждого ОписаниеБлокируемогоРеквизита Из Форма.ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если ОписаниеБлокируемогоРеквизита.ПравоРедактирования
		И НЕ ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено Тогда
			ВсеРеквизитыРазблокированы = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ВсеРеквизитыРазблокированы Тогда
		Форма.Элементы.РазрешитьРедактированиеРеквизитовОбъекта.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает массив имен реквизитов, заданных в свойстве формы
// ПараметрыЗапретаРедактированияРеквизитов на основе имен реквизитов
// указанных в модуле мененджера объекта, исключая реквизиты,
//  у которых Видимость = Ложь и ПравоРедактирования = Ложь.
//
// Параметры:
//  Форма        - Форма объекта с обязательным стандартным реквизитом Объект
//  ТолькоЗаблокированные - Булево, начальное значение Истина,
//               для вспомогательных целей можно задать Ложь, чтобы
//               получить список всех видимых реквизитов, которые могут разблокироваться.
//
// Возвращаемое значение:
//  Массив - имена реквизитов
//
Функция РеквизитыКромеНевидимых(Знач Форма, Знач ТолькоЗаблокированные = Истина) Экспорт
	
	РеквизитыКромеНевидимых = Новый Массив;
	
	Для Каждого ОписаниеБлокируемогоРеквизита Из Форма.ПараметрыЗапретаРедактированияРеквизитов Цикл
		
		Если ОписаниеБлокируемогоРеквизита.ПравоРедактирования
		   И (    ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено = Ложь
		      ИЛИ ТолькоЗаблокированные = Ложь) Тогда
			
			СуществуетВидимоеПоле = Ложь;
			Для Каждого БлокируемыйЭлементФормы Из ОписаниеБлокируемогоРеквизита.БлокируемыеЭлементы Цикл
				ЭлементФормы = Форма.Элементы.Найти(БлокируемыйЭлементФормы.Значение);
				Если ЭлементФормы <> Неопределено И ЭлементФормы.Видимость Тогда
					СуществуетВидимоеПоле = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если СуществуетВидимоеПоле Тогда
				РеквизитыКромеНевидимых.Добавить(ОписаниеБлокируемогоРеквизита.ИмяРеквизита);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РеквизитыКромеНевидимых;
	
КонецФункции

// Выводит предупреждение о том, что все видимые реквизиты разблокированы.
//   Необходимость в предупреждении возникает, когда команда разблокировки
// остается включенной из-за наличия невидимых неразблокированных реквизитов.
//
Процедура ПредупреждениеВсеВидимыеРеквизитыРазблокированы() Экспорт
	
	Предупреждение(НСтр("ru = 'Редактирование всех видимых реквизитов объекта уже разрешено.'"));
	
КонецПроцедуры
