
Declare 
@Numgen1 INT, 
@NumGen2 as Int, 
@NumGen3 as Int, 
@NumGen4 as Int, 
@NumGen5 as Int, 

@Company as Varchar(80), 
@Type as Varchar (50),
@Name as Varchar(100),
@Action as Varchar (75),
@ReleaseDate as date,
@addUser as varchar(50), 
@ToyName as Varchar (120), 
@Object as Varchar (25), 

@DateStart	Date = '2001-01-01',
@DateEnd	Date = '2018-01-01',

@cnt as int = 0

While @cnt <100

Begin
set @numgen1 = abs(checksum(NewId()) % 12)+1
set @NumGen2 = abs(checksum(NewId()) % 12)+1
set @NumGen3 = abs(checksum(NewId()) % 12)+1
set @NumGen4 = abs(checksum(NewId()) % 12)+1
set @NumGen5 = abs(checksum(NewId()) % 12)+1


set @Company = 	Case @NumGen1
				when 1 then 'Wham-O'
				when 2 then 'Marx'
				when  3 then 'Mattel'
				when  4 then 'Arrow'
				when 5 then 'Migo'
				when  6 then 'Ideal'
				when 7 then 'Hasbro'
				when  8 then 'Kenner'
				when 9 then 'Duplo'
				when 10 then 'Lego'
				when  11 then 'WizKids'
				when 12 then 'Games Workshop'
				end

set @Type = 	Case @NumGen2
				when 1 then 'Ball'
				when 2 then 'Game'
				when  3 then 'Puzzle'
				when  4 then 'Outdoor'
				when 5 then 'Lawn'
				when  6 then 'Action Figure'
				when 7 then 'Car'
				when  8 then 'Doll'
				when 9 then 'Stuffed'
				when 10 then 'Desktop'
				when  11 then 'Bubble'
				when 12 then 'Model'
				end

set @Name = 	Case @NumGen3
				when 1 then 'Super'
				when 2 then 'Elastic'
				when  3 then 'Wacky'
				when  4 then 'Amazing'
				when 5 then 'Compact'
				when  6 then 'Miniature'
				when 7 then 'Hungry'
				when  8 then 'Silly'
				when 9 then 'Spy'
				when 10 then 'Skill'
				when  11 then 'Spinning'
				when 12 then 'Master'
				end

set @Action = 	Case @NumGen4
				when 1 then 'Wetting'
				when 2 then 'Wobbling'
				when  3 then 'Walking'
				when  4 then 'Returning'
				when 5 then 'Talking'
				when  6 then 'Popping'
				when 7 then 'Bouncing'
				when  8 then 'Flying'
				when 9 then 'Swimming'
				when 10 then 'Rolling'
				when  11 then 'Standing'
				when 12 then 'Electronic'

				
			end 
Set @ReleaseDate =  DateAdd(Day, Rand() * DateDiff(Day,@DateStart,@DateEnd), @DateStart)

set @Object = 	Case @NumGen2
				when 1 then 'Game'
				when 2 then 'Board'
				when  3 then 'Jigsaw'
				when  4 then 'Only for'
				when 5 then 'Sprinkling'
				when  6 then 'Articulated'
				when 7 then 'Speedy'
				when  8 then 'Baby'
				when 9 then 'Animal,'
				when 10 then 'Game for the'
				when  11 then 'Boomba'
				when 12 then 'Realistic'
				end




--Select DateAdd(Day, Rand() * DateDiff(Day, @DateStart, @DateEnd), @DateStart)

Set @AddUser = 	Case @NumGen5
				when 1 then 'SClaus'
				when 2 then 'EBunny'
				when  3 then 'Luigi'
				when  4 then 'Mario'
				when 5 then 'Bubba'
				when  6 then 'Lois'
				when 7 then 'Scully'
				when  8 then 'Bingo'
				when 9 then 'Wally'
				when 10 then 'Alexa'
				when  11 then 'Siri'
				when 12 then 'Neener'
				End

Set @ToyName = (@Name + ' ' + @Action + ' ' + @Object + ' ' + @Type)


select @Company, @type, @Name, @Action, @ReleaseDate, @AddUser, @ToyName
--Insert Into dbo.Toy (Company, Type,Name, ReleaseDate, AddUser ) VALUES (@company, @Type, @ToyName, @ReleaseDate, @AddUser );


Set @cnt = @cnt+1
End;

