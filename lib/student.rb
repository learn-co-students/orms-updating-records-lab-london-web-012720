require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  @@all = []

  def initialize (name, grade, id = nil)
     @name = name
     @grade = grade
     @id = id
     @@all << self
  end


  def self.create_table

    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, name, grade)
  end

  def self.new_from_db(row)
    stu = Student.new(row[1], row[2], row[0])
    stu
  end

  def self.find_by_name(n)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    SQL
     
    self.new_from_db(DB[:conn].execute(sql, n)[0])
  end


  def save

    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
    
      DB[:conn].execute(sql, self.name, self.grade)

      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end


  def self.drop_table
    sql = <<-SQL 
    DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(sql)
  end

end

