CREATE OR REPLACE FUNCTION update_team_name()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.team_name IS NULL OR NEW.team_name NOT IN ('Dinamo', 'Ak Bars') THEN
        NEW.team_name := 'No team';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER before_insert_player
    BEFORE INSERT
    ON player
    FOR EACH ROW
EXECUTE FUNCTION update_team_name();