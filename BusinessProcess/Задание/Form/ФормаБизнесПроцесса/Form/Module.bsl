﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачальныйПризнакСтарта = Объект.Стартован;
	ТолькоПросмотр = Объект.Завершен;
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокПроверкиВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.Дата.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	Элементы.Предмет.Гиперссылка = Объект.Предмет <> Неопределено И НЕ Объект.Предмет.Пустая();
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);	
	Элементы.ГруппаСостояние.Видимость = Объект.Завершен;
	Если Объект.Завершен Тогда
		ДатаЗавершенияСтрокой = ?(ИспользоватьДатуИВремяВСрокахЗадач, 
			Формат(Объект.ДатаЗавершения, "ДЛФ=DT"), Формат(Объект.ДатаЗавершения, "ДЛФ=D"));
		ТекстСостояния = ?(Объект.Выполнено, 
			НСтр("ru = 'Задание выполнено %1.'"), 
			НСтр("ru = 'Задание отменено %1.'"));	
		Элементы.ДекорацияТекст.Заголовок =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСостояния,	
				ДатаЗавершенияСтрокой);
	КонецЕсли;
	
	Если Объект.ГлавнаяЗадача = Неопределено Или Объект.ГлавнаяЗадача.Пустая() Тогда
		Элементы.ГлавнаяЗадача.Гиперссылка = Ложь;
		ГлавнаяЗадачаСтрокой = НСтр("ru = 'не задана'");
	Иначе	
		ГлавнаяЗадачаСтрокой = Строка(Объект.ГлавнаяЗадача);
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы") Тогда
		Элементы.ГлавнаяЗадача.Видимость = Ложь;
	КонецЕсли;	
	
	ИспользоватьВнешниеЗадачиИБизнесПроцессы = БизнесПроцессыИЗадачиПереопределяемый.ИспользоватьВнешниеЗадачиИБизнесПроцессы();
	УстановитьДоступностьПроверяющего(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	Если НачальныйПризнакСтарта И ИзменятьЗаданияЗаднимЧислом Тогда
		УстановитьПривилегированныйРежим(Истина); 
		ТекущийОбъект.ИзменитьРеквизитыНевыполненныхЗадач();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_Задание", ПараметрыЗаписи, Объект.Ссылка);
	Оповестить("Запись_ЗадачаИсполнителя", ПараметрыЗаписи, Неопределено);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НаПроверкеПриИзменении(Элемент)
	
	УстановитьДоступностьПроверяющего(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	Если ТипЗнч(Объект.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.Предмет);
	Иначе	
		ОткрытьЗначение(Объект.Предмет);
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ГлавнаяЗадачаНажатие(Элемент, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.ГлавнаяЗадача);
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ВыбратьИсполнителя(
		Элемент, Объект.Исполнитель, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если ТипЗнч(Объект.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(Объект.Исполнитель) Тогда 
		
		Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Исполнитель, "ИспользуетсяСОбъектамиАдресации") Тогда 
			Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборРолиИсполнителя", 
				Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
					Объект.Исполнитель, 
					ОсновнойОбъектАдресации, 
					ДополнительныйОбъектАдресации), 
				ЭтаФорма);
			
			Если ТипЗнч(Результат) = Тип("Структура") Тогда
				Объект.Исполнитель = Результат.РольИсполнителя;
			КонецЕсли;
		КонецЕсли;	
		
	КонецЕсли;	
	
	УстановитьДоступностьПроверяющего(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		
		Объект.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
		
		Модифицированность = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ВыбратьИсполнителя(
		Элемент, Объект.Проверяющий, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийПриИзменении(Элемент)
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если ТипЗнч(Объект.Проверяющий) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(Объект.Проверяющий) Тогда 
		
		Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Проверяющий, "ИспользуетсяСОбъектамиАдресации") Тогда 
			Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборРолиИсполнителя", 
				Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
					Объект.Проверяющий, 
					ОсновнойОбъектАдресации, 
					ДополнительныйОбъектАдресации), 
				ЭтаФорма);
			
			Если ТипЗнч(Результат) = Тип("Структура") Тогда
				Объект.Проверяющий = Результат.РольИсполнителя;
			КонецЕсли;
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		
		Объект.Проверяющий = ВыбранноеЗначение.РольИсполнителя;
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	Если Объект.СрокИсполнения = НачалоДня(Объект.СрокИсполнения) Тогда
		Объект.СрокИсполнения = КонецДня(Объект.СрокИсполнения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СрокПроверкиПриИзменении(Элемент)
	Если Объект.СрокПроверки = НачалоДня(Объект.СрокПроверки) Тогда
		Объект.СрокПроверки = КонецДня(Объект.СрокПроверки);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Остановить(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОстановитьБизнесПроцессИзФормыОбъекта(ЭтаФорма);
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПродолжитьБизнесПроцессИзФормыОбъекта(ЭтаФорма);
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьДоступностьКомандОстановки()
	
	Если Объект.Завершен Тогда
		
		Элементы.ФормаОстановить.Доступность = Ложь;
		Элементы.ФормаПродолжить.Доступность = Ложь;
		Возврат;
		
	КонецЕсли;
	
	Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Остановлен") Тогда
		Элементы.ФормаОстановить.Доступность = Ложь;
		Элементы.ФормаПродолжить.Доступность = Истина;
	Иначе
		Элементы.ФормаОстановить.Доступность = Истина;
		Элементы.ФормаПродолжить.Доступность = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПроверяющего(Форма)
	
	ДоступностьПоля = Форма.Объект.НаПроверке;
	Форма.Элементы.ГруппаПроверяющий.Доступность = ДоступностьПоля;
	
	Если Не Форма.ИспользоватьВнешниеЗадачиИБизнесПроцессы Тогда
		Возврат;
	КонецЕсли;
		
	Если ТипЗнч(Форма.Объект.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") 
		И ЗначениеЗаполнено(Форма.Объект.Исполнитель) Тогда 	
		
		ВнешняяРоль = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Форма.Объект.Исполнитель, "ВнешняяРоль");
		
		Если ВнешняяРоль Тогда
			Форма.Объект.Проверяющий = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
			Форма.Объект.НаПроверке = Ложь;
			Форма.Элементы.ГруппаПроверка.Доступность = Ложь;
		Иначе	
			Форма.Элементы.ГруппаПроверка.Доступность = Истина;
		КонецЕсли;	
	Иначе	
		Форма.Элементы.ГруппаПроверка.Доступность = Истина;
	КонецЕсли;
		
КонецПроцедуры		

