CREATE OR REPLACE FUNCTION update_team_id_on_players()
    RETURNS TRIGGER AS
$$
DECLARE
    old_team_id BIGINT;
BEGIN
    SELECT id_team
    INTO old_team_id
    FROM team_player
    WHERE id_player = OLD.id_player;

    UPDATE team
    SET players_count = players_count - 1
    WHERE id_team = old_team_id;

    IF NEW.team_name IS NULL OR NEW.team_name NOT IN ('Dinamo', 'Ak Bars') THEN
        NEW.team_name := 'No team';
    END IF;

    SELECT id_team
    INTO NEW.team_id
    FROM team
    WHERE team.name_team = NEW.team_name;

    UPDATE team_player
    SET id_team = NEW.team_id
    WHERE id_player = NEW.id_player;

    UPDATE team
    SET players_count = players_count + 1
    WHERE id_team = NEW.team_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_update_player
    BEFORE UPDATE OF team_name
    ON player
    FOR EACH ROW
EXECUTE FUNCTION update_team_id_on_players();