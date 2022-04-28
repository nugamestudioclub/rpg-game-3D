using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombatController : MonoBehaviour
{

    [SerializeField]
    private GameObject button;
    public enum Turn
    {
        PlayerTurn,
        EnemyTurn,
        InTurn
    }

    [HideInInspector]
    public Turn currentTurn = Turn.PlayerTurn;


    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (currentTurn == Turn.PlayerTurn)
        {
            Cursor.visible = true;
            button.GetComponent<SpriteRenderer>().enabled = true;
            currentTurn = Turn.InTurn;
        }
        else if (currentTurn == Turn.EnemyTurn)
        {
            StartCoroutine(EnemyAttack());
            currentTurn = Turn.InTurn;
        }
    }

    IEnumerator EnemyAttack()
    {
        yield return new WaitForSeconds(5);
        currentTurn = Turn.PlayerTurn;
    }

}
