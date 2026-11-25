<?php

header('Content-Type: application/json; charset=utf-8');

try {
    require '/etc/smartwallet/database.php';

    $method = $_SERVER['REQUEST_METHOD'];

    switch ($method) {

        case 'GET':

            $stmt = $pdo->query(
                "SELECT * FROM documents ORDER BY id"
            );

            echo json_encode(
                $stmt->fetchAll(),
                JSON_UNESCAPED_UNICODE
            );

            break;

        case 'POST':

            $data = json_decode(
                file_get_contents('php://input'),
                true
            );

            if (
                !is_array($data) ||
                empty($data['nom']) ||
                empty($data['expiration']) ||
                empty($data['reference']) ||
                !in_array($data['couleur'] ?? '', [
                    'vert', 'bleu', 'violet', 'orange', 'noir'
                ], true)
            ) {
                http_response_code(400);
                echo json_encode(['error' => 'Données invalides']);
                break;
            }

            $stmt = $pdo->prepare(
                "INSERT INTO documents
                (nom, type, reference, expiration, couleur, icone)
                VALUES (?, ?, ?, ?, ?, ?)"
            );

            $stmt->execute([
                $data['nom'],
                'Document personnel',
                $data['reference'],
                $data['expiration'],
                $data['couleur'],
                '◇'
            ]);

            http_response_code(201);

            echo json_encode([
                'success' => true,
                'id' => (int) $pdo->lastInsertId()
            ]);

            break;

        case 'DELETE':

            $id = filter_input(
                INPUT_GET,
                'id',
                FILTER_VALIDATE_INT
            );

            if (!$id || $id < 1) {
                http_response_code(400);
                echo json_encode(['error' => 'ID invalide']);
                break;
            }

            $stmt = $pdo->prepare(
                "DELETE FROM documents WHERE id = ?"
            );

            $stmt->execute([$id]);

            if ($stmt->rowCount() === 0) {
                http_response_code(404);
                echo json_encode(['error' => 'Document introuvable']);
                break;
            }

            echo json_encode(['success' => true]);

            break;

        default:

            http_response_code(405);
            echo json_encode(['error' => 'Méthode non autorisée']);
    }

} catch (Throwable $e) {

    http_response_code(500);

    echo json_encode([
        'error' => 'Erreur du serveur'
    ]);
}
