## Маскировка и анонимизация данных

- Замаскировать поля с конфиденциальными данными.
- Провести анонимизацию данных.

### Порядок выполнения работы:

- Установить расширение `PostgreSQL Anonymizer`
- Выбрать поля, которые необходимо замаскировать и модифицируйте уже существующие таблицы или представления.

> https://postgresql-anonymizer.readthedocs.io/en/stable/dynamic_masking

- Выбрать данные, которые можно анализировать, скрыв, обобщив конфиденциальные данные.

Создайте три `Materialized Views` используя:

- Generalization - заменяет данные более широкими и менее точными значениями, диапазонами.

> https://postgresql-anonymizer.readthedocs.io/en/latest/generalization

- Используйте 2 стратегии анонимизации из списка:
    - `Destruction`
    - `Adding Noise`
    - `Randomization`
    - `Faking`
    - `Advanced Faking`
    - `Pseudonymization`
    - `Generic Hashing`
    - `Partial scrambling`

> https://postgresql-anonymizer.readthedocs.io/en/stable/masking_functions

Продемонстрировать, как работает маскировка на данных, `Materialized Views`, сами данные из БД, а так же код.