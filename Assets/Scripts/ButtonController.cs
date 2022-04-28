using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonController : MonoBehaviour
{
    [SerializeField]
    private GameObject player;

    // Start is called before the first frame update
    void Start()
    {
        this.GetComponent<SpriteRenderer>().enabled = false;
        Debug.Log(this.GetComponent<SpriteRenderer>().enabled);
    }

    // Update is called once per frame
    void Update()
    {
       
    }

    private void OnMouseDown()
    {
        this.GetComponent<SpriteRenderer>().enabled = false;
        Cursor.visible = false;
        player.GetComponent<CombatController>().currentTurn = CombatController.Turn.EnemyTurn;
    }
}
