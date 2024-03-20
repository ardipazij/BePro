CREATE OR REPLACE FUNCTION register_player_trigger()
    RETURNS TRIGGER AS
$$
declare
    team_id INT;
BEGIN
    INSERT INTO autorisation (id_player, username, password)
    VALUES (NEW.id_player, NEW.username, NEW.password);

    SELECT id_team INTO team_id FROM team WHERE team.name_team = NEW.team_name;

    IF NOT FOUND THEN
        team_id := 0;
    END IF;

    INSERT INTO team_player (id_team, id_player, player_position)
    VALUES (team_id, NEW.id_player, NEW.player_position);

    INSERT INTO statistic (id_person)
    VALUES (NEW.id_player);

    UPDATE team
    SET players_count = players_count + 1
    WHERE id_team = team_id;

    UPDATE player
    SET team_id = team.id_team
    FROM team
    WHERE player.id_player = NEW.id_player
      AND team.name_team = NEW.team_name;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create trigger after_register
    after insert
    on player
    for each row
execute function register_player_trigger();
